class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:device_token, :supplier_notification, :email_attachment, :update_chat_id]
  before_action :current_customer, only: [:device_token, :supplier_notification, :update_chat_id]

  def current_customer
    token = request.headers['Authorization'].presence
    if token
      @current_customer ||= Customer.find_by_authentication_token(token)
    end
  end

  # def supplier_list
  #   suppliers = Company.all
  #   render json: {success: true, suppliers: suppliers.as_json(only: [:id, :name])}
  # end

  # def tender_by_months
  #   months = Tender.group("month(open_date)").count
  #   data = []
  #   months.each do |month|
  #     data << { month: month[0], tender_count: month[1] }
  #   end
  #   render json: { data: data }
  # end

  def filter_data
    suppliers = Company.all.map { |e| { id: e.id, name: e.name}  }
    months = Tender.group("month(open_date)").count
    countries = Tender.group("country").count
    data = []
    data_countries = []
    countries.each do |country|
      unless country[0].nil? || country[0].blank?
        data_countries << { name: country[0], tender_count: country[1] }
      end
    end
    months.each do |month|
      data << { month: month[0], tender_count: month[1] }
    end
    render json: { suppliers: suppliers, months: data, location: data_countries, response_code: 200  }
  end

  def device_token
    if current_customer
      if params[:customer][:token].present?
        device = Device.new(device_params)
        device.customer_id = current_customer.id
        if device.save
          render json: {success: true, device_token: device.token, type: device.device_type, response_code: 200 }
        else
          render json: {success: false, message: device.errors.full_messages, response_code: 201 }
        end
      else
        render json: {success: false, message: 'Please use correct parameter', response_code: 201 }
      end
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
  end

  def supplier_notification
    if current_customer
      supplier_notification = SupplierNotification.where(customer_id: current_customer.id, supplier_id: params[:supplier_id]).first_or_initialize
      supplier_notification.notify = params[:notify]
      if supplier_notification.save
        render json: {success: true, supplier_notification: supplier_notification.as_json(only: [:supplier_id, :notify]), response_code: 200 }
      else
        render json: {success: false, errors: supplier_notification.errors.full_messages, response_code: 201 }
      end
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
  end

  def get_suppliers
    if current_customer
      companies = Company.all
      render json: { success: true, supplier_notifications: suppliers_data(companies, current_customer), response_code: 200 }
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
  end

  def email_attachment
    if current_customer
      attachment = EmailAttachment.new(attachment_params)
      attachment.customer_id = current_customer.id
      if attachment.save
        # need to send an email to admin
        TenderMailer.send_attachment_to_admin(attachment, attachment.customer).deliver
        render json: { success: true, attachment: attachment, response_code: 200 }
      else
        render json: {success: false, message: attachment.errors.full_messages, response_code: 201 }
      end
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
  end

  def customer_list
    customers = Customer.all
    render json: { customers: customers.as_json(only: [:id, :first_name, :last_name, :email, :company, :chat_id]), response_code: 200}
  end

  def update_chat_id
    if current_customer
      current_customer.chat_id = params[:chat_id]
      current_customer.save(validate: false)
      render json: {success: true, customer: current_customer.as_json(only: [:first_name, :last_name, :email, :company, :chat_id]), response_code: 200 }
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
  end

  private

  def device_params
    params.require(:customer).permit(:token, :device_type)
  end

  def suppliers_data(suppliers, customer)
    @data = []
    suppliers.each do |supplier|
      @data << {
        supplier_id: supplier.id,
        supplier_name: supplier.name,
        is_notified: customer.notify_by_supplier(supplier)
      }
    end
    @data
  end

  def attachment_params
    params.require(:email_attachment).permit(:file,:tender_id)
  end
end
