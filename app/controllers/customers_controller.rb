class CustomersController < ApplicationController
  include CustomersHelper
  before_action :authenticate_customer!
  # before_action :authenticate_admin!
  before_action :check_info_shared, only: [:shared_info]
  before_action :check_role_authorization, except: [:access_denied, :profile]
  before_action :can_approve_access, only: [:approve, :approve_access]
  skip_before_action :check_request_access, only: [:access_denied]

  def profile
    @customer = current_customer
  end

  def info
    @total_transaction = Transaction.total_transaction(current_company.id).count
    @pending_transactions = Transaction.pending_received_transaction(current_company.id).count + Transaction.pending_sent_transaction(current_company.id).count
    @overdue_transactions = Transaction.overdue_received_transaction(current_company.id).count + Transaction.overdue_sent_transaction(current_company.id).count
    @complete_transactions = Transaction.complete_received_transaction(current_company.id).count + Transaction.complete_sent_transaction(current_company.id).count
    @total_pending_received = Transaction.pending_received_transaction(current_company.id).sum(:total_amount)
    @total_pending_sent = Transaction.pending_sent_transaction(current_company.id).sum(:total_amount)
    @total_overdue_received = Transaction.overdue_received_transaction(current_company.id).sum(:total_amount)
    @total_overdue_sent = Transaction.overdue_sent_transaction(current_company.id).sum(:total_amount)
    @total_complete_received = Transaction.complete_received_transaction(current_company.id).sum(:total_amount)
    @total_complete_sent = Transaction.complete_sent_transaction(current_company.id).sum(:total_amount)
    @credit_recieved = CreditLimit.where('buyer_id =?',current_company.id)
    @credit_given = CreditLimit.where('seller_id =?',current_company.id)
    @shared = Shared.new
    @shared_table = Shared.where(shared_by_id: current_company.id)
    @credit_recieved_transaction = Transaction.where('buyer_id =?',current_company.id)
    @credit_given_transaction = Transaction.where('seller_id =?',current_company.id)
  end

  def scores

  end

  def shared
    @check_duplicate = Shared.where(shared_to_id: params[:shared][:shared_to_id], shared_by_id: current_company.id)
    if @check_duplicate.present?
      redirect_to info_customers_path, notice: "Already shared."
    else
      @shared = Shared.new(shared_params)
      if @shared.shared_to_id.nil?
        redirect_to info_customers_path, notice: "Select company first."
      else
        @shared.shared_by_id = current_company.id
        if @shared.save
          TenderMailer.shared_info_email(current_company, @shared.shared_to_id).deliver_now
          redirect_to info_customers_path, notice: "shared successfully"
        end
      end
    end
  end

  def shared_info
    @total_transaction = Transaction.total_transaction(params[:id]).count
    @pending_transactions = Transaction.pending_received_transaction(params[:id]).count + Transaction.pending_sent_transaction(params[:id]).count
    @overdue_transactions = Transaction.overdue_received_transaction(params[:id]).count + Transaction.overdue_sent_transaction(params[:id]).count
    @complete_transactions = Transaction.complete_received_transaction(params[:id]).count + Transaction.complete_sent_transaction(params[:id]).count
    @total_pending_received = Transaction.pending_received_transaction(params[:id]).sum(:total_amount)
    @total_pending_sent = Transaction.pending_sent_transaction(params[:id]).sum(:total_amount)
    @total_overdue_received = Transaction.overdue_received_transaction(params[:id]).sum(:total_amount)
    @total_overdue_sent = Transaction.overdue_sent_transaction(params[:id]).sum(:total_amount)
    @total_complete_received = Transaction.complete_received_transaction(params[:id]).sum(:total_amount)
    @total_complete_sent = Transaction.complete_sent_transaction(params[:id]).sum(:total_amount)
    @credit_recieved = CreditLimit.where('buyer_id =?',params[:id])
    @credit_given = CreditLimit.where('seller_id =?',params[:id])
    @customer = Customer.find(params[:id])
    @credit_recieved_transaction = Transaction.where('buyer_id =?',params[:id])
    @credit_given_transaction = Transaction.where('seller_id =?',params[:id])
  end

  def transaction_list
    @company = Company.where(id: params[:id]).first
    unless @company.nil?
      if params[:type] == 'pending'
       @transactions = Transaction.pending_received_transaction(@company.id) + Transaction.pending_sent_transaction(@company.id)
      elsif params[:type] == "complete"
        @transactions = Transaction.complete_received_transaction(@company.id) + Transaction.complete_sent_transaction(@company_id)
      elsif params[:type] == "overdue"
        @transactions = Transaction.overdue_received_transaction(@company.id) + Transaction.overdue_sent_transaction(@company.id)
      end
    else
      redirect_to trading_customers_path
    end
  end

  def index
    @customer = Customer.all
  end

  def destroy
    @shared_user = Shared.find(params[:id])
    @shared_user.destroy
    @shared_table = Shared.where(shared_by_id: current_customer.id)
    respond_to do |format|
      format.js { render 'shared_customer' }
    end
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
      BlockUser.where(block_company_ids: params[:block_company_id], company_id: current_company.id).first_or_create
    else
      BlockUser.where(block_company_ids: params[:block_company_id], company_id: current_company.id).first.destroy
    end
    # @companies = Company.where.not(id: current_company.id).order(company: :asc).page params[:page]
    respond_to do |format|
      format.js { render 'block_unblock' }
      format.html { redirect_to credit_suppliers_path }
      format.json {render json: {status: params[:status], result: result}}
    end
  end

  def update_password
    @customer = current_customer
    if @customer.update(password_params)
      bypass_sign_in(@customer)
      flash[:notice] = "Password changed successfully."
      redirect_to trading_customers_path
    else
      render 'change_password'
    end
  end

  def trading
    @history = []
    @info = []
    @proposal = Proposal.new
    # customer_id = BlockUser.where(block_company_ids: current_company.id).map { |e| e.company_id }
    # @parcels = TradingParcel.where(sold: false).where.not(company_id: current_company.id).order(created_at: :desc) #.page params[:page]
    @my_parcels = TradingParcel.where(company_id: current_company.id, sold: false).where.not(source: 'POLISHED').order(created_at: :desc)
    @polished_parcels = TradingParcel.where(company_id: current_company.id, sold: false, source: 'POLISHED').order(created_at: :desc)
  end

  def demanding
    @demanding_parcel = Demand.new
    @dtc_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 1, deleted: false)
    @russian_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 2, deleted: false)
    @outside_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 3, deleted: false)
    @something_special_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 4, deleted: false)
    @polished_demands = PolishedDemand.where(company_id: current_company.id, demand_supplier_id: 5, deleted: false)
    if current_company.is_overdue
      @disable = true
    else
      @disable = false
    end
  end

  def demanding_search
    @history = []
    @info = []
    @proposal = Proposal.new
    @demanding_parcel = Demand.new
    if params[:demand].present?
      full_description = params[:demand][:description].reject { |c| c.empty? }
      if full_description.present?
        parcels = TradingParcel.where(sold: false).where("trading_parcels.source = ? AND (trading_parcels.description IN (?))", params[:demand][:demand_supplier_id], full_description)
      else
        parcels = TradingParcel.where(sold: false).where("trading_parcels.source = ?", params[:demand][:demand_supplier_id])
      end
    else
      parcels = TradingParcel.where(sold: false) #.page(params[:page]).per(25)
    end
    required_parcels = []
    dtc_parcels = []
    outside_parcels = []
    something_special_parcels =[]
    polished_parcels = []
    russian_parcels = []
    parcels.each do |parcel|
      if check_parcel_visibility(parcel, current_company)
        if parcel.source == 'OUTSIDE GOODS'
           outside_parcels << parcel
        elsif parcel.source == 'POLISHED'
           polished_parcels << parcel
        elsif parcel.source == 'RUSSIAN'
           russian_parcels << parcel
        elsif parcel.source == 'SOMETHING SPECIAL'
           something_special_parcels << parcel
        else parcel.source == 'DTC'
           dtc_parcels << parcel
        end
      end
    end
    @dtc = dtc_parcels
    @russian = russian_parcels
    @something_special = something_special_parcels
    @polished = polished_parcels
    @outside = outside_parcels
  end

  def demanding_create
    description = params[:demand][:description].reject { |c| c.empty? }
    if params[:demand][:demand_supplier_id].present? && !description.blank?
      demand_supplier = DemandSupplier.where(name: params[:demand][:demand_supplier_id]).first
      description.each do |d|
        @demanding_parcel = Demand.where(description: d, company_id: current_company.id, demand_supplier_id: demand_supplier.id).first_or_create do |demand|
          demand.weight = params[:demand][:weight]
          demand.price = params[:demand][:price]
          demand.diamond_type = params[:demand][:diamond_type]
          demand.block = false
          demand.deleted = false
        end
      end
      flash[:notice] = "Demand created successfully."
      redirect_to demanding_customers_path
    else
      flash[:alert] = "Please check fields value..."
      redirect_to demanding_customers_path
    end
  end

  def demand_from_search
    demand_supplier = DemandSupplier.where(name: params[:demand_supplier]).first
    description = params[:description].reject { |c| c.empty? }
    if params[:demand_supplier].blank? || params[:description].blank?
      flash[:alert] = "Please fill the parameters"
      redirect_to demanding_search_customers_path
    else
      description.each do |d|
        @demanding_parcel = Demand.where(description: d, company_id: current_company.id, demand_supplier_id: demand_supplier.id).first_or_create do |demand|
          demand.weight = params[:weight]
          demand.price = params[:price]
          demand.diamond_type = params[:diamond_type]
          demand.block = false
          demand.deleted = false
        end
      end
      if @demanding_parcel.save!
        flash[:notice] = "Demand created successfully."
        redirect_to demanding_search_customers_path
      else
        flash[:notice] = "Something went wrong. Please try again."
        redirect_to demanding_search_customers_path
      end
    end
  end

  def search_trading
    @parcels = TradingParcel.search_by_filters(params[:search], current_customer).page params[:page]
    respond_to do |format|
      format.js { render 'customers/trading/search_trading' }
    end
  end

  def transactions
    @pending_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date >= ? AND paid = ?", current_company.id, Date.today, false).page params[:page]
    @overdue_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ?", current_company.id, Date.today, false).page params[:page]
    @complete_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND paid = ?", current_company.id, true).page params[:page]
    @rejected_transactions = Proposal.includes(:trading_parcel).where("status = ? AND buyer_id = ?", 2, current_company.id).page params[:page]
  end

  def credit
    @credit_limit = [] #CreditLimit.where(buyer_id: current_customer.id)
    @customers = [] #Customer.unscoped.where.not(id: current_customer.id)
  end

  def check_info_shared
    check = Shared.where('shared_by_id = ? and shared_to_id = ?', params[:id], current_company)
    if check.present?
      # do nothing
    else
      redirect_to trading_customers_path, notice: "You are not authorized."
    end
  end

  def remove_demand
    demand = params[:type] == 'POLISHED' ? PolishedDemand.find_by(id: params[:id]) : Demand.find_by(id: params[:id])
    if demand.present?
      demand.update_attributes(deleted: true)
      flash[:notice] = "Demand deleted successfully."
      redirect_to demanding_customers_path
    else
      flash[:error] = "No Record Found!"
      redirect_to demanding_customers_path
    end
  end

  def approve_access
    # @customers = current_company.customers.where(is_requested: true)
    @customers = current_company.customers.where.not(id: current_customer.id)
  end

  def approve
    customer = Customer.find(params[:cu])
    if customer.update_attributes(is_requested: false)
      CustomerMailer.approve_access(customer).deliver
      redirect_to approve_access_customers_path, notice: 'Access granted'
    else
      redirect_to approve_access_customers_path, alert: customer.errors.full_messages.first
    end
  end

  def remove
    customer = Customer.find(params[:cu])
    if customer.update_attributes(is_requested: true)
      CustomerMailer.remove_access(customer).deliver
      redirect_to approve_access_customers_path, notice: 'Access Denied successfully!!'
    else
      redirect_to approve_access_customers_path, alert: customer.errors.full_messages.first
    end
  end

  def access_denied
  end

  def polished_demand
    @demand_list =  DemandSupplier.find_by(name: 'POLISHED').try(:demand_list)
    @polished_demand = PolishedDemand.new
  end

  def create_polished_demand
    @polished_demand = PolishedDemand.new(polished_demand_params)
    if @polished_demand.save
      redirect_to demanding_customers_path
    else
      @demand_list =  DemandSupplier.find_by(name: 'POLISHED').try(:demand_list)
      render :polished_demand
    end
  end

  def live_demands
    ids = current_company.block_users
    @normal_demands = Demand.where.not(company_id: ids).order(created_at: :desc)
    @polished_demands = PolishedDemand.where.not(company_id: ids).order(created_at: :desc)
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :mobile_no, :phone_2, :phone, :address, :city, :company, :company_address, :certificate)
  end

  def password_params
    params.require(:customer).permit(:password, :password_confirmation)
  end

  def shared_params
    params.require(:shared).permit(:shared_to_id)
  end

  def demanding_params
    params.require(:demand).permit(:description, :weight, :price, :diamond_type)
  end

  def polished_demand_params
    params.require(:polished_demand).permit!
  end

  def can_approve_access
    first_customer = current_company.get_owner
    if first_customer == current_customer
      # Do Nothing
    else
      redirect_to root_path, alert: "You are not authorized"
    end
  end
end
