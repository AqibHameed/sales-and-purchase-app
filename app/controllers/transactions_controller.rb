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

  def invite
    @customer = Customer.new
    render :partial=> 'invite'
  end

  def invite_send
    Customer.invite!(email: params[:customer][:email], first_name: params[:customer][:first_name],company: params[:customer][:company],mobile_no: params[:customer][:mobile_no] )
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
      TenderMailer.payment_received_email(@transaction, @payment).deliver rescue logger.info "Error sending email" 
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

  def confirm
    @transaction = Transaction.find(params[:id])
    @transaction.buyer_confirmed = true
    if @transaction.save
      redirect_to trading_history_path, notice: 'Transaction confirm successfully'
    else
      redirect_to trading_history_path, notice: 'Not confirm now. Please try again.'
    end
  end

  def show
    @transaction = Transaction.find(params[:id])
    @payment = PartialPayment.new
    @payment_details = PartialPayment.where(transaction_id: params[:id])
  end

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    @transaction = Transaction.find(params[:id])
    unless params[:weight].blank?
      @transaction.trading_parcel.update_column(:weight, params[:weight])
    end
    if @transaction.update_attributes(update_transaction_params)
      redirect_to transaction_path(@transaction)
    else
      render :edit
    end
  end

  # def reject_reason
  #   @transaction = Transaction.find(params[:id])
  #   @transaction.reject_reason = params[:transaction][:reject_reason]
  #   @transaction.buyer_rejected = true
  #   @transaction.reject_date = Time.now
  #   if @transaction.save(validate: false)
  #     Message.create_message(@transaction)
  #     redirect_to trading_history_path, notice: 'Transaction rejected successfully'
  #   else
  #     redirect_to trading_history_path, notice: 'Not rejected now. Please try again.'
  #   end
  # end

  private
  def parcel_transaction_params
    params.require(:trading_parcel).permit(:customer_id, :credit_period, :lot_no, :description, :no_of_stones, :weight, :price, :source, :box, :cost, :box_value, :sight, :sold, :diamond_type,
                                        my_transaction_attributes: [:buyer_id, :supplier_id, :trading_parcel_id, :price, :credit, :paid, :created_at, :transaction_type, :weight, :diamond_type, :buyer_confirmed ])
  end

   def partial_payment_params
    params.require(:partial_payment).permit(:amount,:transaction_id)
  end

  def invite_params
    params.require(:customer).permit(:first_name,:company,:mobile_no,:email)
  end

  def update_transaction_params
    params.require(:transaction).permit(:paid, :total_amount, :price, :invoice_no, :ready_for_buyer)
  end
end