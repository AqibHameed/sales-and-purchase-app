class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery with: :exception
  before_action :set_paper_trail_whodunnit
  helper_method :current_company
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_request_access
  def user_for_paper_trail
    customer_signed_in? ? current_customer.id : 'Guest'
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def info_for_paper_trail
    { ip: request.remote_ip }
  end

  def current_ability
    if current_customer
      @current_ability ||= Ability.new(current_customer)
    elsif current_admin
      @current_ability ||= Ability.new(current_admin)
    end
  end

  def check_role_authorization
    if current_admin.present?
      # do nothing
    else
      if current_customer.has_role?('Buyer') ||  current_customer.has_role?('Seller')
        # do nothing
      else
        if current_customer.has_role?('Broker')
          redirect_to '/brokers', notice: 'You are not authorized.'
        else
          redirect_to root_path, notice: 'You are not authorized.'
        end
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :first_name, :last_name, :city, :address, :postal_code, :phone, :status, :company_id, :company_address, :phone_2, :mobile_no, :role, :is_requested, :company_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :first_name, :last_name, :city, :address, :postal_code, :phone, :status, :company, :company_address, :phone_2, :mobile_no])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :company, :mobile_no, :password, :password_confirmation])
  end

  before_action :set_user_language
  # def after_sign_in_path_for(resource)
  #   set_cookies_for_user(resource) if !cookies[:c_user]
  #   if resource.is_a?(Admin)
  #     '/admins'
  #   else resource.is_a?(Customer)
  #     if resource.has_role?('Broker')
  #       dashboard_brokers_path
  #     else
  #       root_path
  #     end
  #   end
  # end

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

  def current_company
    @comapny ||= current_customer.company
  end

  def check_request_access
    if customer_signed_in?
      if current_customer.is_requested
        redirect_to access_denied_path, notice: 'You are not allowed to access. Please contact your company admin.'
      else
        # Do Nothing
      end
    end
  end

  private

  def set_user_language
    I18n.locale = 'en'
  end
end

