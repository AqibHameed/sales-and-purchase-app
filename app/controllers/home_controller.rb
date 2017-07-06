class HomeController < ApplicationController

  # layout false
  def login
    cookies.delete :c_user if params[:key] && cookies[:c_user]
    @c_user = Customer.find_by_email(cookies[:c_user]) || Admin.find_by_email(cookies[:c_user]) if cookies[:c_user]
    sign_out current_customer
    sign_out current_admin
  end

end

