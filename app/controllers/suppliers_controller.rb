class SuppliersController < ApplicationController
  # layout 'supplier', :except => [:profile]
  # layout 'application', :except => [:profile]
  before_action :authenticate_customer!, except: [:add_demand_list, :upload_demand_list, :check_role_authorization]
  before_action :authenticate_admin!, only: [:add_demand_list, :upload_demand_list]
  before_action :check_role_authorization, only: [:index, :trading, :credit ]

  def index
    @parcels = TradingParcel.where(customer_id: current_customer.id, sold: false).order(created_at: :desc) #.page params[:page]
    @trading_document = TradingDocument.new
    @trading_parcel = TradingParcel.new
    @trading_parcel.parcel_size_infos.build
  end

  def trading
  end

  def important
    credit_limit = CreditLimit.where(buyer_id: params[:id], seller_id: current_customer.id).first
    if credit_limit.present?
      if credit_limit.star == true
        credit_limit.star = false
      else
        credit_limit.star = true
      end
    else
      credit_limit = CreditLimit.new(buyer_id: params[:id], seller_id: current_customer.id, credit_limit: 0, star: true)
    end
    credit_limit.save!
  end

  def profile
    @customer = Customer.find(params[:id])
    render :partial => 'profile'
    # respond_to do |format|
    #   format.html { render :layout => false}
    # end
  end

  def demand
    @parcel = TradingParcel.find(params[:id])
    @demand = Demand.where(description: @parcel.description, block: false, deleted: false).where.not(customer_id: current_customer.id)
    @customers = Customer.where(id: @demand.map(&:customer_id)).page params[:page]
  end

  def add_demand_list
  end

  def upload_demand_list
    DemandList.import(params[:file], params[:supplier])
    redirect_to add_demand_list_suppliers_path, notice: "List imported."
  end

  def parcels
    if params[:trading_document][:document].present?
      if params[:trading_document][:diamond_type] == 'Rough'
        @trading_document = TradingDocument.new(rough_diamond_params)
      else
        @trading_document = TradingDocument.new(sight_diamond_params)
      end
      if @trading_document.save
        flash[:notice] = "Document uploaded successfully"
        redirect_to suppliers_path
      else
        render :trading
      end
    else
      flash[:notice] = "Please attach a document"
      redirect_to trading_suppliers_path
    end
  end

  def single_parcel
    @parcel = TradingParcel.find(params[:id])
    @info = []
  end

  def single_parcel_form
    @trading_parcel = TradingParcel.new
  end

  def transactions
    @pending_transactions = Transaction.includes(:trading_parcel).where("seller_id = ? AND due_date >= ? AND paid = ?", current_customer.id, Date.today, false).page params[:page]
    @overdue_transactions = Transaction.includes(:trading_parcel).where("seller_id = ? AND due_date < ? AND paid = ?", current_customer.id, Date.today, false).page params[:page]
    @complete_transactions = Transaction.includes(:trading_parcel).where("seller_id = ? AND paid = ?", current_customer.id, true).page params[:page]
    @rejected_transactions = Proposal.includes(:trading_parcel).where("status = ? AND seller_id = ?", 2, current_customer.id).page params[:page]
  end

  def credit
    @group_names = []
    if params[:name].present?
      @companies = Customer.eager_load(:company).where('companies.name LIKE ?', "%#{params[:name].downcase}%").where.not(id: current_customer.id)
      # @companies = Customer.where('lower(company) LIKE ?', "%#{params[:name].downcase}%").where.not(id: current_customer.id)
    end
    if params[:letter].present?
      # @customers = Customer.where('lower(company) LIKE ?', "#{params[:letter].downcase}%").where.not(id: current_customer.id)
      @customers = Customer.eager_load(:company).where('companies.name LIKE ?', "%#{params[:letter].downcase}%").where.not(id: current_customer.id)
    else
      # @customers = Customer.where.not(id: current_customer.id)
      @star_customers = CreditLimit.where(seller_id: current_customer.id, star: true).map{|c| c.buyer}
      @custs = Customer.where.not(id: current_customer.id).limit(10) #.page
      @customers = @star_customers + @custs
      @customers = @customers.uniq
    end
    @type = SubCompanyCreditLimit.find_by(sub_company_id: current_customer.id)
    @companies_groups = CompaniesGroup.where("companies_groups.seller_id = ?", current_customer.id)
  end

  def credit_request
    @customer = Customer.new
    current_customer.credit_requests.build
    @credit_requests = current_customer.credit_requests
  end

  def save_credit_request
    if current_customer.update_attributes(credit_request_params)
      Message.create_new_credit_request(current_customer)
      flash[:notice] = "successfully send"
      redirect_to credit_request_suppliers_path
    else
      flash[:notice] = "Error:   Invalid Entry"
      redirect_to credit_request_suppliers_path
    end
  end

  def confirm_request
    @confirm_requests = CreditRequest.where(parent_id: current_customer.id, approve: false)

  end

  def show_request
    @request = CreditRequest.find(params[:id])
  end

  def accept_request
    request = CreditRequest.find(params[:id])
    credit_limit = CreditLimit.where(buyer_id: request.buyer_id, seller_id: request.customer_id).first
    if credit_limit.present?
     credit_limit.credit_limit = request.limit + credit_limit.credit_limit
    else
     credit_limit = CreditLimit.new(
      seller_id: request.customer_id,
      buyer_id: request.buyer_id,
      credit_limit: request.limit)
    end
    if credit_limit.save
      request.approve = true
      request.save
      credit_limit_of_customer = SubCompanyCreditLimit.where(sub_company_id: request.customer_id).first
      if credit_limit_of_customer.present?
        credit_limit_of_customer.credit_limit = request.limit + credit_limit_of_customer.credit_limit
      else
        credit_limit_of_customer.credit_limit = request.limit
      end
      credit_limit_of_customer.save
      flash[:notice] = "Request Accepted"
      redirect_to confirm_request_suppliers_path
    else
      flash[:notice] = "Request is not accepted"
      redirect_to confirm_request_suppliers_path
    end
  end

  def decline_request
    @confirm_requests = CreditRequest.where(parent_id: current_customer.id, approve: false)
    request = CreditRequest.find(params[:id])
    if request.destroy
      flash[:notice] = "request is declined"
      render confirm_request_suppliers_path
    else
      flash[:notice] = "request is not declined"
      redirect_to confirm_request_suppliers_path
    end
  end

  def update_request
   @request = CreditRequest.find(params[:id])
   if @request.update_attributes(:limit => params[:limit])
     respond_to do |format|
      format.js
     end
   else
     flash[:notice] = "Something is wrong."
     redirect_to confirm_request_suppliers_path
   end
  end


  def change_limits
    cl = CreditLimit.where(buyer_id: params[:buyer_id], seller_id: current_customer.id).first_or_initialize
    total_clms = CreditLimit.where(seller_id: current_customer.id).sum(:credit_limit)
    total_limit = params[:limit].to_f
    cl.errors.add(:credit_limit, "should not be negative ") if total_limit < 0

    if current_customer.parent_id.present?
      sub_company_limit = SubCompanyCreditLimit.find_by(sub_company_id: current_customer.id)
      if sub_company_limit.try(:credit_type) == "General"
        limit = sub_company_limit.credit_limit
      elsif sub_company_limit.try(:credit_type) == "Specific"
        limit = cl.credit_limit
        unless limit.present?
          cl.errors.add(:credit_limit, "not set by parent company")
        end
      else
        cl.errors.add(:credit_limit, "not set by parent company")
      end
      if limit.to_f < (total_limit.to_f + total_clms.to_f)
        cl.errors.add(:credit_limit, "can't be greater than assigned limit")
      else
        cl.credit_limit  = total_limit.to_f
      end
    else
      cl.credit_limit  = total_limit.to_f
    end
    if cl.errors.any?
      render json: { message: cl.errors.full_messages.first, value: nil, errors: true }
    else
      if cl.save
        render json: { message: 'Credit Limit updated.', value: cl.credit_limit, errors: false }
      else
        render json: { message: cl.errors.full_messages.first, value: nil, errors: true }
      end
    end
  end

  def change_days_limits
    buyer = Customer.find(params[:buyer_id])
    dl = DaysLimit.where(buyer_id: params[:buyer_id], seller_id: current_customer.id).first_or_initialize
    if dl.days_limit.nil?
      dl.days_limit = params[:limit]
    else
      dl.days_limit = dl.days_limit + params[:limit].to_i
    end
    if dl.save
      render json: { message: 'Days Limit updated.', value: view_context.get_days_limit(buyer, current_customer) }
    else
      render json: { message: dl.errors.full_messages.first, value: '' }
    end
  end

  def change_market_limit
    buyer = Customer.find(params[:buyer_id])
    cl = CreditLimit.where(buyer_id: params[:buyer_id], seller_id: current_customer.id).first_or_create
    cl.credit_limit = 0 unless cl.credit_limit.present?
    cl.market_limit = params[:market_limit]
    if cl.save!
      render json: { message: 'Market Limit updated.', value: view_context.get_market_limit(buyer, current_customer) }
    else
      render json: { message: cl.errors.full_messages.first, value: '' }
    end
  end

  def supplier_demand_list
    if params[:id] == 'Rough'
      params[:id] = 'Outside Goods'
    end
    demand_supplier = DemandSupplier.where(name: params[:id]).first
    @demand_list = DemandList.where(demand_supplier_id: demand_supplier.id)
    respond_to do |format|
      format.js
    end
  end

  def supplier_list
    if params[:page] && params[:page] == "edit"
      @demand_suppliers = DemandSupplier.all
    else
      if params[:diamond_type] == 'Outside Goods'
        params[:diamond_type] = 'Rough'
      end
      @demand_suppliers = DemandSupplier.where(diamond_type: params[:diamond_type])
    end
    respond_to do |format|
      format.js
    end
  end

  def credit_given_list
    @credit_limits = CreditLimit.where(seller_id: current_customer.id)
  end

  private
  def sight_diamond_params
    params.require(:trading_document).permit(:diamond_type, :customer_id, :document, :credit_field, :price_field, :sheet_no, :weight_field, :sight_field, :source_field, :box_field, :cost_field, :box_value_field)
  end

  def rough_diamond_params
    params.require(:trading_document).permit(:diamond_type, :customer_id, :document, :credit_field, :price_field, :lot_no_field, :desc_field, :no_of_stones_field, :sheet_no, :weight_field)
  end

  def check_role_authorization
    if current_customer.has_role?('Seller') || current_customer.has_role?('Broker')
      # do nothing
    else
      redirect_to trading_customers_path, notice: 'You are not authorized.'
    end
  end

  def credit_request_params
    params.require(:customer).permit(:first_name, :company, :mobile_no, credit_requests_attributes: [:buyer_id, :limit, :approve, :customer_id, :parent_id, :_destroy])
  end
end
