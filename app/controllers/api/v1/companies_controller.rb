class Api::V1::CompaniesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token, :current_customer

  def list_company
    @array =[]
    current_customer.companies.each do |company|
      hash = {}
      hash[:company_name] = company.name
      if company.credit_limit.present? && company.market_limit.present?
      hash[:credit_limit] = company.credit_limit
      hash[:market_limit] = company.market_limit
      else
        hash[:credit_limit] = "you need to set first"
        hash[:market_limit] = "you need to set first"
      end
      @array.push(hash)
    end
    render :json => {:success => true, :company=> @array, response_code: 200 }
  end

  def current_customer
    token = request.headers['Authorization'].presence
    if token
      @current_customer ||= Customer.find_by_authentication_token(token)
    end
  end

  def blocked_customers
    if current_customer
      blocked = BlockUser.where(customer_id: current_customer.id)
      render json: { success: true, blocked_customers: blocked.map { |e| { id: e.try(:block_user).try(:id), company: e.block_user.try(:company), first_name: e.block_user.try(:first_name), last_name: e.block_user.try(:last_name), email: e.block_user.try(:email)}}, response_code: 200 }
    end
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized unless current_customer.present?
  end

  def not_found
    render json: {errors: 'Not found', response_code: 201 }, status: 404
  end

  private
  def check_token
    if request.headers["Authorization"].blank?
      render json: {msg: "Unauthorized Request", response_code: 201 }
    end
  end
end
