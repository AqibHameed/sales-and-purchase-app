class TransactionsController < ApplicationController
  layout 'supplier'
  before_action :authenticate_customer!
  
  def new
    @parcel = TradingParcel.new
    @parcel.build_my_transaction
  end

  def create
    @parcel = TradingParcel.new(parcel_transaction_params)
    if @parcel.save
      @parcel.my_transaction.set_due_date
      redirect_to transactions_suppliers_path, notice: "Transaction added."
    else
      render :new
      @parcel.build_my_transaction
    end
  end

  def customer
    # @transactions = Transaction.where(buyer_id: params[:buyer_id], supplier_id: params[:supplier_id])
    @pending_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND supplier_id = ? AND due_date >= ? AND paid = ?", params[:buyer_id], current_customer.id, Date.today, false).page params[:page]
    @overdue_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND supplier_id = ? AND due_date < ? AND paid = ?", params[:buyer_id], current_customer.id, Date.today, false).page params[:page]
    @complete_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND supplier_id = ? AND paid = ?", params[:buyer_id], current_customer.id, true).page params[:page]
  end

  private
  def parcel_transaction_params
    params.require(:trading_parcel).permit(:customer_id, :credit_period, :lot_no, :description, :no_of_stones, :weight, :price, :source, :box, :cost, :box_value, :sight, :sold,
                                        my_transaction_attributes: [:buyer_id, :supplier_id, :trading_parcel_id, :price, :credit, :paid, :created_at ])
  end
end