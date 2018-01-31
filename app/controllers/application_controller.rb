class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def current_ability
    if current_customer
      @current_ability ||= Ability.new(current_customer)
    elsif current_admin
      @current_ability ||= Ability.new(current_admin)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :first_name, :last_name, :city, :address, :postal_code, :phone, :status, :company, :company_address, :phone_2, :mobile_no, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :first_name, :last_name, :city, :address, :postal_code, :phone, :status, :company, :company_address, :phone_2, :mobile_no])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :company, :mobile_no, :password, :password_confirmation])
  end

  before_action :set_user_language
  def after_sign_in_path_for(resource)
    set_cookies_for_user(resource) if !cookies[:c_user]
    if resource.is_a?(Admin)
      '/admins'
    else resource.is_a?(Customer)
      if resource.sign_in_count == 1
        # change_password_customers_path
        login_path
      else
        root_path
      end
    end
  end

  def set_cookies_for_user(resource)
    cookies[:c_user] = {value: resource.email, expires: 2.year.from_now}
  end

  def authenticate_logged_in_user!
    if current_customer.blank? && current_admin.blank?
      redirect_to login_path
    end
  end

  def authenticate_inviter!
    authenticate_admin!(:force => true)
  end

  private

  def set_user_language
    I18n.locale = 'en'
  end
end

