class Api::V1::RegistrationsController < ActionController::Base
	respond_to :json
	
	def create
		response = Customer.create(customer_params)
		render :json=> { success: true, response: response }
	end

	private
	def customer_params
		params.require(:registration).permit(:email, :password, :first_name, :last_name, :city, :address, :postal_code, :phone, :status, :company, :company_address, :phone_2, :mobile_no)
	end
end