class TradingParcelsController < ApplicationController

  before_action :authenticate_customer!
  before_action :authenticate_admin!
  before_action :set_trading_parcel, only: [:show, :edit, :update, :destroy, :check_authenticate_supplier]
  before_action :check_authenticate_supplier, only: [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'Parcel not found'
    redirect_to suppliers_path
  end

  def create
    @parcel = TradingParcel.new(trading_parcel_params)
    if @parcel.save
      redirect_to suppliers_path, notice: 'Parcel created successfully'
    else
      error = @parcel.errors.full_messages.first
      redirect_to suppliers_path, notice: error
    end
  end

  def show
    @proposal = Proposal.new
  end

  def edit
  end

  def update
    if @parcel.update_attributes(trading_parcel_params)
      flash[:notice] = 'Parcel updated successfully'
      redirect_to suppliers_path
    else
      render :edit
    end
  end

  def destroy
    @parcel.destroy
    flash[:notice] = 'Parcel deleted successfully'
    redirect_to suppliers_path
  end

  private
  def trading_parcel_params
    params.require(:trading_parcel).permit(:customer_id, :credit_period, :lot_no, :description, :no_of_stones, :weight, :price, :source, :box, :cost, :box_value, :sight)
  end

  def set_trading_parcel
    @parcel = TradingParcel.find(params[:id])
  end

  def check_authenticate_supplier
    if current_customer.id == @parcel.customer_id
    else
      flash[:notice] = 'You are not authorized for this action'
      redirect_to suppliers_path
    end
  end
end