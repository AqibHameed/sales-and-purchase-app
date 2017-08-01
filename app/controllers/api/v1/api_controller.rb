class Api::V1::ApiController < ApplicationController
  # skip_before_action :authenticate_user!

  def current_customer
    token = request.headers['Authorization'].presence
    if token
      @current_customer ||= Customer.find_by_authentication_token(token)
    end
  end

  def supplier_list
    suppliers = Company.all
    render json: {success: true, suppliers: suppliers.as_json(only: [:id, :name])}
  end

  def tender_by_months
    months = Tender.group("month(open_date)").count
    data = []
    months.each do |month|
      data << { month: month[0], tender_count: month[1] }
    end
    render json: { data: data }
  end

end