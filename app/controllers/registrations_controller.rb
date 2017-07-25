class RegistrationsController < Devise::RegistrationsController 
	def create 
		super do
		    if resource
		      resource.companies.create(name: params[:name],email: params[:email],status: params[:status])
	    end
  	end
	end

	private
	  def company_params
	    params.permit!
	  end

  protected
  
  def after_sign_up_path_for(resource)
  	'/customers/'+resource.id.to_s+'/add_company'
  end
end