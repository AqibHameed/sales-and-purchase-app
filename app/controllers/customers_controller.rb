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
      BlockUser.where(block_user_ids: params[:block_user_id], customer_id: current_customer.id).first_or_create
    else
      BlockUser.where(block_user_ids: params[:block_user_id], customer_id: current_customer.id).first.destroy
    end
    @customers = Customer.unscoped.where.not(id: current_customer.id).order('created_at desc').page params[:page]
    respond_to do |format|
      format.js {render 'block_unblock'}
      format.json {render json: {status: params[:status], result: result}}
    end
  end

  def update_password
    @customer = current_customer
    if @customer.update(password_params)
      bypass_sign_in(@customer)
      flash[:notice] = "Password changed successfully."
      redirect_to root_path
    else
      render 'change_password'
    end
  end

  def trading
    customer_id = BlockUser.where(block_user_ids: current_customer.id).map { |e| e.customer_id }
    @parcels = TradingParcel.where(sold: false, for_sale: true).where.not(customer_id: customer_id).order(created_at: :desc).page params[:page]
  end

  def search_trading
    @parcels = TradingParcel.search_by_filters(params[:search], current_customer).page params[:page]
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
    @credit_limit = CreditLimit.where(buyer_id: current_customer.id)
    @customers = Customer.unscoped.where.not(id: current_customer.id)
  end

  def check_for_sale
    @trading_parcel = TradingParcel.find_by_id(params[:id])
    @trading_parcel.update_attribute(:for_sale, !@trading_parcel.for_sale)
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :mobile_no, :phone_2, :phone, :address, :city, :company, :company_address, :certificate)
  end

  def password_params
    params.require(:customer).permit(:password, :password_confirmation)
  end
end

