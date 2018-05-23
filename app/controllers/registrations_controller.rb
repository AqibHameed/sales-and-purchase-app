class RegistrationsController < Devise::RegistrationsController
  # def create
  #   super do
  #     if resource.valid?
  #       resource.companies.create(name: params[:name],email: params[:email],status: params[:status])
  #     end
  #   end
  # end

  private
  
  def company_params
    params.permit!
  end

  protected

  def after_sign_up_path_for(resource)
    # '/customers/'+resource.id.to_s+'/add_company'
    trading_customers_path
  end
end