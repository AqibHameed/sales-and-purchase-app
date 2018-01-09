class SuppliersController < ApplicationController
  layout 'supplier', :except => [:profile]
  layout 'application', :except => [:profile]
  before_action :authenticate_customer!
  # before_action :authenticate_admin!

  def index
    @parcels = TradingParcel.where(customer_id: current_customer.id, sold: false).order(created_at: :desc).page params[:page]
    @trading_document = TradingDocument.new
    @trading_parcel = TradingParcel.new
  end

  def trading
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
    @demand = Demand.where(description: @parcel.description).where.not(customer_id: current_customer.id)
    @customers = Customer.unscoped.where(id: @demand.map(&:customer_id)).page params[:page]
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
  end

  def single_parcel_form
    @trading_parcel = TradingParcel.new
  end

  def transactions
    @pending_transactions = Transaction.includes(:trading_parcel).where("supplier_id = ? AND due_date >= ? AND paid = ?", current_customer.id, Date.today, false).page params[:page]
    @overdue_transactions = Transaction.includes(:trading_parcel).where("supplier_id = ? AND due_date < ? AND paid = ?", current_customer.id, Date.today, false).page params[:page]
    @complete_transactions = Transaction.includes(:trading_parcel).where("supplier_id = ? AND paid = ?", current_customer.id, true).page params[:page]
    @rejected_transactions = Proposal.includes(:trading_parcel).where("status = ? AND supplier_id = ?", 2, current_customer.id).page params[:page]
  end

  def credit
    if params[:name].present?
      @companies = Customer.where('lower(company) LIKE ?', "%#{params[:name].downcase}%").where.not(id: current_customer.id)
    end
    @customers = Customer.unscoped.where.not(id: current_customer.id).page params[:page]
  end

  def change_limits
    cl = CreditLimit.where(buyer_id: params[:buyer_id], supplier_id: current_customer.id).first_or_initialize
    if cl.credit_limit.nil?
      cl.credit_limit = params[:limit]
    else
      cl.credit_limit = cl.credit_limit + params[:limit].to_f
    end
    if cl.save
      render json: { message: 'Credit Limit updated.', value: cl.credit_limit }
    else
      render json: { message: cl.errors.full_messages.first, value: '' }
    end
  end

  def change_days_limits
    buyer = Customer.find(params[:buyer_id])
    dl = DaysLimit.where(buyer_id: params[:buyer_id], supplier_id: current_customer.id).first_or_initialize
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

  def supplier_demand_list
    @demand_list = DemandList.where(supplier_id: params[:id])
    respond_to do |format|
      format.js
    end
  end

  def credit_given_list
    @credit_limits = CreditLimit.where(supplier_id: current_customer.id)
  end

  private
  def sight_diamond_params
    params.require(:trading_document).permit(:diamond_type, :customer_id, :document, :credit_field, :price_field, :sheet_no, :weight_field, :sight_field, :source_field, :box_field, :cost_field, :box_value_field)
  end

  def rough_diamond_params
    params.require(:trading_document).permit(:diamond_type, :customer_id, :document, :credit_field, :price_field, :lot_no_field, :desc_field, :no_of_stones_field, :sheet_no, :weight_field)
  end
end
