class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery with: :exception

  before_action :set_user_language
  def after_sign_in_path_for(resource)
    set_cookies_for_user(resource) if !cookies[:c_user]
    if resource.is_a?(Admin)
      '/admins'
    else resource.is_a?(Customer)
      if resource.sign_in_count == 1
        change_password_customers_path
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

  private

  def set_user_language
    I18n.locale = 'en'
  end
end
