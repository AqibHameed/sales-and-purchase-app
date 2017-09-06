class TradingParcelsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_trading_parcel, only: [:show, :edit, :update, :destroy, :check_authenticate_supplier]
  before_action :check_authenticate_supplier, only: [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'Parcel not found'
    redirect_to suppliers_path
  end

  def show
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

  # def share
  #   puts '2332323232'
  #   render partial: 'share'
  # end

  private
  def trading_parcel_params
    params.require(:trading_parcel).permit(:credit_period, :lot_no, :description, :no_of_stones, :weight, :price)
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