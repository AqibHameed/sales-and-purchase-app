class Api::V1::RegistrationsController < ActionController::Base
  def create
    customer = Customer.new(customer_params)
    if customer.save
      customer.ensure_authentication_token
      customer.save!
      response.headers['Authorization'] = customer.authentication_token
      render :json => { customer: customer_data(customer), response_code: 200 }
    else
      render :json => {:errors => customer.errors.full_messages, response_code: 201 }
    end
  end

  private
  def customer_data(customer)
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
      company: customer.company,
      company_address: customer.company_address,
      phone_2: customer.phone_2,
      mobile_no: customer.mobile_no,
      authentication_token: customer.authentication_token,
      chat_id: customer.chat_id
    }
  end

  def customer_params
    params.require(:registration).permit(:email, :password, :first_name, :last_name, :city, :address, :postal_code, :phone, :status, :company, :company_address, :phone_2, :mobile_no)
  end
end