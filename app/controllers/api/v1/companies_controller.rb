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
		render :json => {:success => true, :company=> @array}
	end
	
		def current_customer
		   token = request.headers['Authorization'].presence
		   if token
		     @current_customer ||= Customer.find_by_auth_token(token)
		   end
		 end

	 def authenticate_with_token!
	   render json: { errors: "Not authenticated"}, status: :unauthorized unless current_customer.present?
	 end

	 def not_found
	   render json: {errors: 'Not found' }, status: 404
	 end

	 private
	 def check_token
	   if request.headers["Authorization"].blank?
	     render json: {msg: "Unauthorized Request"}
	   end
   end
end
