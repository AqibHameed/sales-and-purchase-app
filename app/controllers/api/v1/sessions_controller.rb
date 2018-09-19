class Api::V1::SessionsController < Devise::SessionsController
  before_action :ensure_params_exist, except: [:destroy, :customer_by_token]
  skip_before_action :verify_authenticity_token

  def create
    customer = Customer.where(email: params[:customer][:email]).first
    return invalid_login_attempt unless customer
    if customer.valid_password?(params[:customer][:password])
      if customer.confirmed?
        if customer.is_requested
          render :json => { success: false, message: 'Company admin has not provided access.', response_code: 201 }
        else
          sign_in(:customer, customer)
          customer.ensure_authentication_token
          if customer.save
            response.headers['Authorization'] = customer.authentication_token
            token = customer.generate_jwt_token
            render :json => { customer: customer_data(customer, token), response_code: 200 }
          else
            render :json => { errors: customer.errors.full_messages, response_code: 201 }
          end
        end
      else
        render :json => { success: false, message: 'Please verify the email.', response_code: 201 }
      end
      return
    end
    invalid_login_attempt
  end

  def customer_by_token
    token = request.headers['Authorization']
    customer = Customer.where(authentication_token: token).first
    jwt_token = customer.generate_jwt_token
    if customer.present?
      render :json => { customer: customer_data(customer, jwt_token), response_code: 200 }
    else
      render :json => { success: false, message: 'Customer does not exist for this token.', response_code: 201 }
    end
  end

  def destroy
    auth_token = request.headers['Authorization']
    customer = Customer.where(authentication_token: auth_token).first
    return invalid_attempt unless customer
    customer.authentication_token = nil
    if customer.save
      render :json => {:success => true, response_code: 200}
    else
      render :json => {:errors => customer.errors.full_messages, response_code: 201}
    end
  end

  protected
  def customer_data(customer, token)
    {
      id: customer.id,
      email:  customer.email,
      designation: customer.has_role?('Broker') ? 'Broker' : 'Buyer/Seller',
      created_at: customer.created_at,
      updated_at: customer.updated_at,
      first_name: customer.first_name,
      last_name: customer.last_name,
      city: customer.city,
      address: customer.address,
      postal_code: customer.postal_code,
      phone: customer.phone,
      status: customer.status,
      company: customer.company.try(:name),
      company_address: customer.company_address,
      phone_2: customer.phone_2,
      mobile_no: customer.mobile_no,
      authentication_token: customer.authentication_token,
      chat_id: customer.chat_id,
      token: token
    }
  end

  def ensure_params_exist
    return unless params[:customer].blank?
    render :json => {:success => false, :message => "Missing user login parameter", response_code: 201}, :status => 422
  end

  def invalid_login_attempt
    render :json => {:success => false, :message => "Error with your login or password.", response_code: 201}, :status => 401
  end

  def invalid_attempt
    render :json => {:success => false, :message => "Invalid attempt.", response_code: 201}, :status => 401
  end
end



