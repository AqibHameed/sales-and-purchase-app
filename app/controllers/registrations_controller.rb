class RegistrationsController < Devise::RegistrationsController
  layout false
  respond_to :html, :js

  def create
    # company = Company.where(name: sign_up_params[:company_name]).first_or_create
    if sign_up_params[:company_id].present?
       company = Company.find(sign_up_params[:company_id]) 
    else
      if params[:company_individual].present?
        if params[:company_individual] == "Individual" && sign_up_params[:role] == 'Broker'
          string = "#{sign_up_params[:first_name]}"+"#{sign_up_params[:last_name]}"+"("+"#{sign_up_params[:role]}"+")"
          company = Company.where(name: string).first_or_create
          params[:customer].delete("company_id")
          params[:customer].merge!("company_id"  =>  company.id)
        end
      end
    end
    # puts sign_up_params[:company_id]
    # sign_up_params[:company_id] = company.id
    build_resource(sign_up_params)
    unless sign_up_params[:role].blank? || sign_up_params[:company_id].blank?
      if sign_up_params[:role] == 'Broker'
        company.try(:customers).present? ? resource.errors.add(:company, 'already registered as buyer/seller') : ''
      else
        company.is_broker ? resource.errors.add(:company, 'already registered as broker') : ''
      end
    end
    resource.save unless resource.errors.present?
    yield resource if block_given?

    if resource.persisted? && !resource.errors.present?
      if resource.active_for_authentication?
        if resource.is_requested
          # set_flash_message! :notice, :is_requested
          flash[:notice] = "Your request has been sent to #{company.get_owner.name}. When your account is approved, you will receive an e-mail."
          respond_with resource, location: after_signup_when_requested(resource)
        else
          respond_with resource, location: after_sign_up_path_for(resource)
        end
      else
        flash[:notice] =find_message "signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
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
    root_path
  end

  def after_signup_when_requested(resource)
    login_path
  end

  def after_inactive_sign_up_path_for(resource)
    login_path
  end
end
