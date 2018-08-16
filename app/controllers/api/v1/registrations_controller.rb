class Api::V1::RegistrationsController < ActionController::Base
  def create
    # check_company = Company.where(name: params[:registration][:company_id]).first
    # if check_company.customer
    #   is_requested = false
    # else
    #   check_company = check_company
    #   is_requested = true
    # end
    customer = Customer.new(customer_params.merge(role: 'Buyer/Seller'))
    # customer = Customer.new(customer_params)
    if customer.save
      customer.ensure_authentication_token
      mobile_no = '+'+params[:registration][:country_code]+' '+params[:registration][:mobile_no]
      customer.mobile_no = mobile_no
      customer.save!
      response.headers['Authorization'] = customer.authentication_token
      token = customer.generate_jwt_token
      if customer.confirmed?
        if customer.is_requested
          render :json => { success: true, message: 'A request has been to sent to your company admin for approval. You can access your account after approval', response_code: 200 }
        else
          render :json => { success: true, customer: customer_data(customer, token), response_code: 200 }
        end
      else
        render :json => { success: true, message: 'An email has been sent to your email. Please verify the email.', response_code: 200 }
      end
    else
      # check_company.destroy unless check_company.try(:customers).present?
      render :json => {:errors => customer.errors.full_messages, response_code: 201 }
    end
  end

  private
  def customer_data(customer, token)
    {
      id: customer.id,
      email:  customer.email,
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

  def customer_params
    params.require(:registration).permit(:email, :password, :first_name, :last_name, :city, :address, :postal_code, :phone, :status, :company_address, :phone_2, :mobile_no, :company_id, :company_name)
  end
end