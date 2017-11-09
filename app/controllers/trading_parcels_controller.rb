class TradingParcelsController < ApplicationController

  before_action :authenticate_customer!
  # before_action :authenticate_admin!
  before_action :set_trading_parcel, only: [:show, :edit, :update, :destroy, :check_authenticate_supplier]
  before_action :check_authenticate_supplier, only: [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'Parcel not found'
    redirect_to suppliers_path
  end

  def create
    @parcel = TradingParcel.new(trading_parcel_params)
    if @parcel.save
      if params[:trading_parcel][:single_parcel].present?
        redirect_to single_parcel_supplier_path(@parcel), notice: 'Parcel created successfully'
      else
        redirect_to suppliers_path, notice: 'Parcel created successfully'
      end
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

  def message
    @message = Message.new
    @customer = Customer.find(params[:id])
  end

  def message_create
    @message = Message.new(message_params)
    @message.sender_id = current_customer.id
    @message.receiver_id = params[:id]
    if @message.save
      redirect_to trading_parcel_path
    end
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

  def message_params
    params.require(:message).permit(:subject, :message, :message_type)
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