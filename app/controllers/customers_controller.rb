class CustomersController < ApplicationController

  before_action :authenticate_customer!
  # before_action :authenticate_admin!
  before_action :check_info_shared, only: [:shared_info]
  before_action :check_role_authorization, only: [:trading, :demanding]

  def profile
    @customer = current_customer
  end

  def info
    @total_transaction = Transaction.total_transaction(current_customer.id).count
    @pending_transactions = Transaction.pending_received_transaction(current_customer.id).count + Transaction.pending_sent_transaction(current_customer.id).count
    @overdue_transactions = Transaction.overdue_received_transaction(current_customer.id).count + Transaction.overdue_sent_transaction(current_customer.id).count
    @complete_transactions = Transaction.complete_received_transaction(current_customer.id).count + Transaction.complete_sent_transaction(current_customer.id).count
    @total_pending_received = Transaction.pending_received_transaction(current_customer.id).sum(:total_amount)
    @total_pending_sent = Transaction.pending_sent_transaction(current_customer.id).sum(:total_amount)
    @total_overdue_received = Transaction.overdue_received_transaction(current_customer.id).sum(:total_amount)
    @total_overdue_sent = Transaction.overdue_sent_transaction(current_customer.id).sum(:total_amount)
    @total_complete_received = Transaction.complete_received_transaction(current_customer.id).sum(:total_amount)
    @total_complete_sent = Transaction.complete_sent_transaction(current_customer.id).sum(:total_amount)
    @credit_recieved = CreditLimit.where('buyer_id =?',current_customer.id)
    @credit_given = CreditLimit.where('supplier_id =?',current_customer.id)
    @shared = Shared.new
    @shared_table = Shared.where(shared_by_id: current_customer.id)
    @credit_recieved_transaction = Transaction.where('buyer_id =?',current_customer.id)
    @credit_given_transaction = Transaction.where('supplier_id =?',current_customer.id)
  end

  def shared
    @check_duplicate = Shared.where(shared_to_id: params[:shared][:shared_to_id], shared_by_id: current_customer.id)
    if @check_duplicate.present?
      redirect_to info_customers_path, notice: "Already shared."
    else
      @shared = Shared.new(shared_params)
      if @shared.shared_to_id.nil?
        redirect_to info_customers_path, notice: "Select company first."
      else
        @shared.shared_by_id = current_customer.id
        if @shared.save
          TenderMailer.shared_info_email(current_customer, @shared.shared_to_id).deliver_now
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
    @credit_given = CreditLimit.where('supplier_id =?',params[:id])
    @customer = Customer.find(params[:id])
    @credit_recieved_transaction = Transaction.where('buyer_id =?',params[:id])
    @credit_given_transaction = Transaction.where('supplier_id =?',params[:id])
  end

  def transaction_list
    @customer = Customer.where(id: params[:id]).first
    unless @customer.nil?
      if params[:type] == 'pending'
       @transactions = Transaction.pending_received_transaction(@customer.id) + Transaction.pending_sent_transaction(@customer.id)
      elsif params[:type] == "complete"
        @transactions = Transaction.complete_received_transaction(@customer.id) + Transaction.complete_sent_transaction(@customer_id)
      elsif params[:type] == "overdue"
        @transactions = Transaction.overdue_received_transaction(@customer.id) + Transaction.overdue_sent_transaction(@customer.id)
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
      BlockUser.where(block_user_ids: params[:block_user_id], customer_id: current_customer.id).first_or_create
    else
      BlockUser.where(block_user_ids: params[:block_user_id], customer_id: current_customer.id).first.destroy
    end
    @customers = Customer.unscoped.where.not(id: current_customer.id).order(company: :asc).page params[:page]
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
    customer_id = BlockUser.where(block_user_ids: current_customer.id).map { |e| e.customer_id }
    @parcels = TradingParcel.where(sold: false).where.not(customer_id: customer_id).order(created_at: :desc) #.page params[:page]
    @my_parcels = TradingParcel.where(customer_id: current_customer.id, sold: false).order(created_at: :desc)
  end

  def demanding
    @demanding_parcel = Demand.new
    @dtc_demands = Demand.where(customer_id: current_customer.id, demand_supplier_id: 1, deleted: false)
    @russian_demands = Demand.where(customer_id: current_customer.id, demand_supplier_id: 2, deleted: false)
    @outside_demands = Demand.where(customer_id: current_customer.id, demand_supplier_id: 3, deleted: false)
    @something_special_demands = Demand.where(customer_id: current_customer.id, demand_supplier_id: 4, deleted: false)
    if current_customer.is_overdue
      # current_customer.block_demands
      @disable = true
    else
      # current_customer.unblock_demands
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
        description = full_description
      else
        # description = ''
        if params[:demand][:diamond_type] == "Outside Goods"
          description = TradingParcel.where(sold: false).where("trading_parcels.diamond_type = ? AND (trading_parcels.source = ? OR trading_parcels.source = ?)",'Rough','',params[:demand][:demand_supplier_id]).pluck(:description)
        else
          description = TradingParcel.where(sold: false).where("trading_parcels.diamond_type = ? and trading_parcels.source = ?", params[:demand][:diamond_type], params[:demand][:demand_supplier_id]).pluck(:description)
        end
      end
      if params[:demand][:diamond_type] == "Outside Goods"
        parcels = TradingParcel.where(sold: false).where("trading_parcels.diamond_type = ? AND (trading_parcels.source = ? OR trading_parcels.source = ?) AND (trading_parcels.description IN (?))",'Rough','',params[:demand][:demand_supplier_id],description)
      else
        parcels = TradingParcel.where(sold: false).where("trading_parcels.diamond_type = ? and trading_parcels.source = ? and trading_parcels.description IN (?) or trading_parcels.box IN (?)", params[:demand][:diamond_type], params[:demand][:demand_supplier_id], description, description)
      end
   else
    parcels = TradingParcel.where(sold: false) #.page(params[:page]).per(25)
   end

    aa = parcels.where("(customer_id = #{current_customer.id}) OR (sale_all = true) OR (sale_none = false) OR (sale_broker = true and broker_ids IN (#{current_customer.id.to_s}) ) OR (sale_credit = true) OR (sale_demanded = true)")
    ss = aa.where(sale_demanded: true)
    if ss.exists?
      demand = Demand.where(description: aa.pluck(:description), customer_id: current_customer.id)
      @parcels1 = aa.where(description: demand.pluck(:description))
    else
      @parcels1 = aa
    end
    mm = aa.where(sale_credit: true)
    credit_limit = CreditLimit.where(supplier_id: aa.pluck(:customer_id),buyer_id: current_customer.id)
    if credit_limit.exists?
      @parcels2 = mm.where("customer_id != ?",credit_limit.pluck(:supplier_id))
    else
      @parcels2 = mm
    end
    @parcels = @parcels1+@parcels2
    @parcels = @parcels.uniq
  end

  def demanding_create
    demand_supplier = DemandSupplier.where(name: params[:demand][:demand_supplier_id]).first
    description = params[:demand][:description].reject { |c| c.empty? }
    description.each do |d|
      @demanding_parcel = Demand.where(description: d, customer_id: current_customer.id, demand_supplier_id: demand_supplier.id).first_or_create do |demand|
        demand.weight = params[:demand][:weight]
        demand.price = params[:demand][:price]
        demand.diamond_type = params[:demand][:diamond_type]
        demand.block = false
        demand.deleted = false
      end
    end
    if @demanding_parcel.save
      flash[:notice] = "Demand created successfully."
      redirect_to demanding_customers_path
    else
      flash[:notice] = "Something went wrong. Please try again."
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
        @demanding_parcel = Demand.where(description: d, customer_id: current_customer.id, demand_supplier_id: demand_supplier.id).first_or_create do |demand|
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
    @pending_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date >= ? AND paid = ?", current_customer.id, Date.today, false).page params[:page]
    @overdue_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ?", current_customer.id, Date.today, false).page params[:page]
    @complete_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND paid = ?", current_customer.id, true).page params[:page]
    @rejected_transactions = Proposal.includes(:trading_parcel).where("status = ? AND buyer_id = ?", 2, current_customer.id).page params[:page]
  end

  def credit
    @credit_limit = [] #CreditLimit.where(buyer_id: current_customer.id)
    @customers = [] #Customer.unscoped.where.not(id: current_customer.id)
  end

  def check_for_sale
    @trading_parcel = TradingParcel.find_by_id(params[:id])
    @trading_parcel.update_attributes(params[:col].to_sym => params[:val])
  end

  def check_info_shared
    check = Shared.where('shared_by_id = ? and shared_to_id = ?', params[:id], current_customer)
    if check.present?
      # do nothing
    else
      redirect_to trading_customers_path, notice: "You are not authorized."
    end
  end

  def remove_demand
    demand = Demand.where(id: params[:id]).first
    if demand.present?
      demand.update_attributes(deleted: true)
      flash[:notice] = "Dmeand deleted successfully."
      redirect_to demanding_customers_path
    else
      flash[:error] = "No Record Found!"
      redirect_to demanding_customers_path
    end
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

  def check_role_authorization
    if current_admin.present?
      # do nothing
    else
      if current_customer.has_role?('Buyer') || current_customer.has_role?('Broker')
        # do nothing
      else
        redirect_to trading_customers_path, notice: 'You are not authorized.'
      end
    end
  end

end

