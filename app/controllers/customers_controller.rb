class CustomersController < ApplicationController

  before_action :authenticate_customer!
  def profile
    @customer = current_customer
  end

  def update_profile
    @customer = current_customer
    if @customer.update_attributes(params[:customer])
      redirect_to profile_customers_path, :notice => 'Profile_updated_successfully'
    else
      render 'profile'
    end
  end

  def change_password
    @customer = current_customer
  end

  def update_password
    @customer = current_customer
    if @customer.update_attributes(params[:customer])
      sign_in @customer, :bypass => true
      flash[:message] = "Password changed successfully."
      redirect_to root_path
    else
      render 'change_password'
    end
  end

end

