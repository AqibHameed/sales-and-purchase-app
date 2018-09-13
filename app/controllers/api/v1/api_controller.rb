class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:device_token, :supplier_notification, :email_attachment, :update_chat_id]
  before_action :current_customer, only: [:device_token, :supplier_notification, :update_chat_id, :customer_list]
  helper_method :current_company

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include ApplicationHelper
  include CustomersHelper

  def current_customer
    token = request.headers['Authorization'].presence
    if token
      @current_customer ||= Customer.find_by_authentication_token(token)
    end
  end

  def app_versions
    if params[:version].present?
      version = AppVersion.where(version: params[:version]).first
      if version.present?
        render json: { success: true, version: version.as_json(except: [:id, :created_at, :updated_at])}
      else
        render json: { success: false, message: "This version does not exist" }
      end
    else
      versions = AppVersion.all
      render json: { success: true, versions: versions.as_json(except: [:id, :created_at, :updated_at])}
    end
  end

  # def tender_by_months
  #   months = Tender.group("month(open_date)").count
  #   data = []
  #   months.each do |month|
  #     data << { month: month[0], tender_count: month[1] }
  #   end
  #   render json: { data: data }
  # end

  def filter_data
    suppliers = Supplier.all.map { |e| { id: e.id, name: e.name}  }
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
      companies = Supplier.all
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
    @customers = Customer.all
    @customers = @customers.where('first_name LIKE ?', "%#{params[:first_name]}%") if params[:first_name].present?
    @customers = @customers.where('last_name LIKE ?', "%#{params[:last_name]}%") if params[:last_name].present?
    @customers = @customers.where('first_name LIKE ? or last_name LIKE ?', "%#{params[:name]}%", "%#{params[:name]}%") if params[:name].present?
    @customers = @customers.page(params[:page]).per(params[:count])
    render json: { pagination: set_pagination(:customers), customers: get_customers_data(@customers, current_customer), response_code: 200 }
  end

  def company_list
    # @companies = Company.all
    if current_company
      if params[:name].present?
        company = Company.where('name LIKE ?', "%#{params[:name]}%")
      else
        company = Company.where.not(id: current_company.id)
      end
      @companies = company.page(params[:page]).per(params[:count])
      render json: { pagination: set_pagination(:companies), companies: companies_data(@companies), response_code: 200 }
    else
      render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
    end
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

  def set_pagination(name, options = {})
    results = instance_variable_get("@#{name}")
    page = {}
    pagination = {}
    if results.current_page <= results.total_pages
      request_params = request.query_parameters
      url_without_params = request.original_url.slice(0..(request.original_url.index("?")-1)) unless request_params.empty?
      url_without_params ||= request.original_url
      page[:first] = 1 if results.total_pages > 1 && !results.first_page?
      page[:last]  = results.total_pages  if results.total_pages > 1 && !results.last_page?
      page[:next]  = results.current_page + 1 unless results.last_page?
      page[:prev]  = results.current_page - 1 unless results.first_page?
      page.each do |k, v|
        page[k] = "#{url_without_params}?page=#{v}#{url_params}"
      end
      pagination = {
        total_pages: results.total_pages,
        prev_page: page[:prev].present? ? page[:prev].to_s : nil,
        next_page: page[:next].present? ? page[:next].to_s : nil,
        current_page: results.current_page
      }
    end
  end

  def url_params
    url = request.url
    uri = URI(url)
    params = CGI.parse(uri.query || "")
    params.delete('page')
    uri.query = URI.encode_www_form(params)
    query = ''
    query = '&'+uri.query unless uri.query.blank?
  end

  protected

  def current_company
    @company ||= current_customer.company unless current_customer.nil?
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

  def get_customers_data(customers, current_customer)
    @data = []
    customers.each do |c|
      unless c.id == current_customer.id
        @data << {
          id: c.id,
          first_name: c.first_name,
          last_name: c.last_name,
          email: c.email,
          company: c.company.try(:name),
          chat_id: c.chat_id
        }
      end
    end
    @data
  end

  def companies_data(companies)
    @data = []
    companies.each do |c|
      status = c.customers.present?
      @data << {
        id: c.id.to_s,
        name: c.name,
        city: c.city,
        country: c.county,
        created_at: c.created_at,
        updated_at: c.updated_at,
        purchases_completed: get_completed_transaction(c),
        suppliers_connected: get_supplier_connected(c.id),
        status: status
      }
    end
    @data
  end

  def attachment_params
    params.require(:email_attachment).permit(:file,:tender_id)
  end

  def get_supplier_connected(buyer)
    count = CreditLimit.where("buyer_id =?", buyer).count
  end

  def get_completed_transaction(company)
    @transactions = Transaction.includes(:trading_parcel).where('(buyer_id = ? or seller_id = ?) and paid = ?',company.id, company.id, true)
    return @transactions.count
  end

end
