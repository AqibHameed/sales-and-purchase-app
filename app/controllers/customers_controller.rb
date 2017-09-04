class CustomersController < ApplicationController

  before_action :authenticate_customer!
  def profile
    @customer = current_customer
  end

  def index
    @customer = Customer.all
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

  def add_company
    @customer =  Customer.find(params[:id])
    @company = Company.new
  end

  def create_sub_company
    @customer =  Customer.find(params[:id])
      params[:company][:sub_companies_attributes].each do |p|
      name = params[:company][:sub_companies_attributes][p][:name]
      email = params[:company][:sub_companies_attributes][p][:email]
      status = params[:company][:sub_companies_attributes][p][:status]
      @customer.companies.last.sub_companies.create(name: name, email: email,status: status,customer_id: @customer.id)
    end
    redirect_to customers_path
  end

  def block_unblock_user
    if params[:status] == 'block'
      user = Customer.find(params[:id])
      result = BlockUser.block_user user,params[:block_user_id]
    else
      current_customer.block_user.block_user_ids.delete(params[:block_user_id])
      block_user = current_customer.block_user.update_attributes(block_user_ids: current_customer.block_user.block_user_ids)
      result = block_user.present?
    end
    respond_to do |format|
      format.json {render json: {status: params[:status], result: result}}
    end
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

  def trading
    @parcels = TradingParcel.where.not(customer_id: current_customer.id)
  end

end

