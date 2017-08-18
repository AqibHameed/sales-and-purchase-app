class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:device_token]
  before_action :current_customer, only: [:device_token]

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
    render json: { suppliers: suppliers, months: data, location: data_countries  }
  end

  def device_token
    if current_customer
      if params[:customer][:token].present?
        device = Device.new(device_params)
        device.customer_id = current_customer.id
        if device.save
          render json: {success: true, device_token: device.token }, status: 200
        else
          render json: {success: false, message: device.errors.full_messages}
        end
      else
        render json: {success: false, message: 'Please use correct parameter'}
      end
    else
      render json: { errors: "Not authenticated"}, status: :unauthorized
    end
  end

  private
  def device_params
    params.require(:customer).permit(:token, :device_type)
  end

end