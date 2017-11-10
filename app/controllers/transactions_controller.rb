class TransactionsController < ApplicationController
  layout 'supplier'
  before_action :authenticate_customer!
  # before_action :authenticate_admin!
  
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

  def payment
    @payment = PartialPayment.new(partial_payment_params)
    @payment.customer_id = current_customer.id

    if @payment.save
      @transaction = Transaction.find(@payment.transaction_id)
      amount = @transaction.remaining_amount
      @transaction.update_column(:remaining_amount, amount - @payment.amount)
      if @transaction.remaining_amount == 0
        @transaction.update_column(:paid, true)
      end
      redirect_to trading_history_path
    else
      error = @payment.errors.full_messages.first
      redirect_to trading_history_path, notice: error
    end

  end

  def customer
    # @transactions = Transaction.where(buyer_id: params[:buyer_id], supplier_id: params[:supplier_id])
    @transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND supplier_id = ? ", params[:buyer_id], current_customer.id).page params[:page]
    # @overdue_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND supplier_id = ? AND due_date < ? AND paid = ?", params[:buyer_id], current_customer.id, Date.today, false).page params[:page]
    # @complete_transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? AND supplier_id = ? AND paid = ?", params[:buyer_id], current_customer.id, true).page params[:page]
  end

  def reject
    @transaction = Transaction.find(params[:id])
  end

  def show
    @transaction = Transaction.find(params[:id])
    @payment = PartialPayment.new
    @payment_details = PartialPayment.where(transaction_id: params[:id])
  end

  def reject_reason
    @transaction = Transaction.find(params[:id])
    @transaction.reject_reason = params[:transaction][:reject_reason]
    @transaction.buyer_rejected = true
    @transaction.reject_date = Time.now
    if @transaction.save(validate: false)
      Message.create_message(@transaction)
      redirect_to trading_history_path, notice: 'Transaction rejected successfully'
    else
      redirect_to trading_history_path, notice: 'Not rejected now. Please try again.'
    end
  end

  private
  def parcel_transaction_params
    params.require(:trading_parcel).permit(:customer_id, :credit_period, :lot_no, :description, :no_of_stones, :weight, :price, :source, :box, :cost, :box_value, :sight, :sold, :diamond_type,
                                        my_transaction_attributes: [:buyer_id, :supplier_id, :trading_parcel_id, :price, :credit, :paid, :created_at, :transaction_type, :weight, :diamond_type ])
  end

   def partial_payment_params
    params.require(:partial_payment).permit(:amount,:transaction_id)
  end
end