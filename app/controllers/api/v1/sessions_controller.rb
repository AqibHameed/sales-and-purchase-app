class Api::V1::SessionsController < Devise::SessionsController
  before_action :ensure_params_exist, except: [:destroy]
  skip_before_action :verify_authenticity_token

  def create
    customer = Customer.where(email: params[:customer][:email]).first
    return invalid_login_attempt unless customer
     if customer.valid_password?(params[:customer][:password])
      sign_in(:customer, customer)
      customer.ensure_authentication_token
      customer.save!
      response.headers['Authorization'] = customer.authentication_token

      render :json => customer, serializer: CustomerSerializer
      return
    end
    invalid_login_attempt
  end

  def destroy
    auth_token = request.headers['Authorization']
    customer = Customer.where(authentication_token: auth_token).first
    return invalid_attempt unless customer
    customer.authentication_token = nil
    if customer.save
      render :json => {:success => true}
    else
      render :json => {:errors => customer.errors.full_messages}
    end
  end

  protected
  def ensure_params_exist
    return unless params[:customer].blank?
    render :json => {:success => false, :message => "Missing user login parameter"}, :status => 422
  end

  def invalid_login_attempt
    render :json => {:success => false, :message => "Error with your login or password."}, :status => 401
  end

  def invalid_attempt
    render :json => {:success => false, :message => "Invalid attempt."}, :status => 401
  end
end



