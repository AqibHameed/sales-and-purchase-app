class TransactionsController < ApplicationController

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save
      redirect_to credit_suppliers_path, notice: "Transaction added."
    else
      render :new
    end
  end

  private
  def transaction_params
    params.require(:transaction).permit(:buyer_id, :supplier_id, :trading_parcel_id, :price, :credit, :due_date, :paid)
  end
end