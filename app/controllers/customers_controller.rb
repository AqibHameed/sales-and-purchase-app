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
    if @customer.update_attributes(customer_params)
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
    @parcels = TradingParcel.where(sold: false).order(created_at: :desc).page params[:page]
  end

  def search_trading
    @parcels = TradingParcel.search_by_filters(params[:search], current_customer)
    respond_to do |format|
      format.js { render 'customers/trading/search_trading' }
    end
  end

  def transactions
    @pending_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date >= ? AND paid = ?", current_customer.id, Date.today, false).page params[:page]
    @overdue_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ?", current_customer.id, Date.today, false).page params[:page]
    @complete_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND paid = ?", current_customer.id, true).page params[:page]
    @rejected_transactions = Proposal.includes(:trading_parcel).where("status = ? AND buyer_id = ?", 2, current_customer.id).page params[:page]
  end

  def credit
    @customers = Customer.unscoped.where.not(id: current_customer.id).order('created_at desc').page params[:page]
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :mobile_no, :phone_2, :phone, :address, :city, :company, :company_address)
  end
end

