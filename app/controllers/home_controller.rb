class HomeController < ApplicationController
  include ApplicationHelper

  # layout false
  def login
    cookies.delete :c_user if params[:key] && cookies[:c_user]
    @c_user = Customer.find_by_email(cookies[:c_user]) || Admin.find_by_email(cookies[:c_user]) if cookies[:c_user]
    sign_out current_customer
    sign_out current_admin
  end

  def verified_unverified
    customer = Customer.where(id: params[:id]).first
    if customer.present?
      if customer.verified?
        render json: { text: get_verified_text(customer) }
      else
        render json: { text: get_unverified_text(customer) }
      end
    end
  end

end

