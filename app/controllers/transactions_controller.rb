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
      redirect_to credit_suppliers_path, notice: "Transaction added."
    else
      render :new
      @parcel.build_my_transaction
    end
  end

  private
  def parcel_transaction_params
    params.require(:trading_parcel).permit(:customer_id, :credit_period, :lot_no, :description, :no_of_stones, :weight, :price, :source, :box, :cost, :box_value, :sight, :sold,
                                        my_transaction_attributes: [:buyer_id, :supplier_id, :trading_parcel_id, :price, :credit, :paid, :created_at ])
  end
end