class Api::V1::RegistrationsController < ActionController::Base
  def create
    customer = Customer.new(customer_params)
    if customer.save
      customer.ensure_authentication_token
      response.headers['Authorization'] = customer.authentication_token

      render :json => customer, serializer: CustomerSerializer
    else
      render :json => {:errors => customer.errors.full_messages}
    end 
  end

  private
  def customer_params
    params.require(:registration).permit(:email, :password, :first_name, :last_name, :city, :address, :postal_code, :phone, :status, :company, :company_address, :phone_2, :mobile_no)
  end
end