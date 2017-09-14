class SuppliersController < ApplicationController
  layout 'supplier'
  before_action :authenticate_customer!

  def index
    @parcels = TradingParcel.where(customer_id: current_customer.id).order(created_at: :desc).page params[:page]
  end

  def trading
    @trading_document = TradingDocument.new
    @trading_parcel = TradingParcel.new
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

  def transactions
    @pending_transactions = Transaction.includes(:trading_parcel).where("supplier_id = ? AND due_date >= ? AND paid = ?", current_customer.id, Date.today, false).page params[:page]
    @overdue_transactions = Transaction.includes(:trading_parcel).where("supplier_id = ? AND due_date < ? AND paid = ?", current_customer.id, Date.today, false).page params[:page]
    @complete_transactions = Transaction.includes(:trading_parcel).where("supplier_id = ? AND paid = ?", current_customer.id, true).page params[:page]
    @rejected_transactions = Proposal.includes(:trading_parcel).where("status = ? AND supplier_id = ?", 2, current_customer.id).page params[:page]
  end

  def credit
    @customers = Customer.unscoped.where.not(id: current_customer.id).order('created_at desc').page params[:page]
    @blocked_users = BlockUser.where(customer_id: current_customer.id).first
  end

  def change_limits
    cl = CreditLimit.where(buyer_id: params[:buyer_id], supplier_id: current_customer.id).first_or_initialize
    cl.credit_limit = params[:limit]
    if cl.save
      render json: { message: 'Credit Limit updated.'}
    else
      render json: { message: cl.errors.full_messages.first }
    end
  end

  private
  def sight_diamond_params
    params.require(:trading_document).permit(:diamond_type, :customer_id, :document, :credit_field, :price_field, :sheet_no, :weight_field, :sight_field, :source_field, :box_field, :cost_field, :box_value_field)
  end

  def rough_diamond_params
    params.require(:trading_document).permit(:diamond_type, :customer_id, :document, :credit_field, :price_field, :lot_no_field, :desc_field, :no_of_stones_field, :sheet_no, :weight_field)
  end
end
