class RegistrationsController < Devise::RegistrationsController

  def create
    company = Company.where(name: sign_up_params[:company_name]).first_or_create
    build_resource(sign_up_params.merge(company_id: company.id))
    if sign_up_params[:role] == 'Broker'
      company.try(:customers).present? ? resource.errors.add(:company, 'Already exists...') : ''
    else
      company.is_broker ? resource.errors.add(:company, 'already registered as broker') : ''
    end
    resource.save unless resource.errors.present?
    yield resource if block_given?
    if resource.persisted? && !resource.errors.present?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      company.destroy unless company.try(:customers).present?
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

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
