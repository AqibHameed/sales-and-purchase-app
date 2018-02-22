class TradingParcelsController < ApplicationController

  before_action :authenticate_customer!
  # before_action :authenticate_admin!
  before_action :set_trading_parcel, only: [:show, :edit, :update, :destroy, :check_authenticate_supplier, :share_broker, :related_seller, :parcel_history]
  before_action :check_authenticate_supplier, only: [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'Parcel not found'
    redirect_to suppliers_path
  end

  def create
    @parcel = TradingParcel.new(trading_parcel_params)
    if @parcel.save
      @parcel.update_column(:diamond_type, params[:trading_document_diamond_type])
      if params[:trading_parcel][:single_parcel].present?
        redirect_to single_parcel_supplier_path(@parcel), notice: 'Parcel created successfully'
      else
        redirect_to trading_customers_path, notice: 'Parcel created successfully'
      end
    else
      error = @parcel.errors.full_messages.first
      redirect_to trading_customers_path, notice: error
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

  def update
    if @parcel.update_attributes(trading_parcel_params)
      flash[:notice] = 'Parcel updated successfully'
      redirect_to trading_customers_path
    else
      render :edit
    end
  end

  def destroy
    @parcel.destroy
    flash[:notice] = 'Parcel deleted successfully'
    redirect_to trading_customers_path
  end

  def share_broker
    @parcel.update_column(:broker_ids, params[:broker_ids])
  end

  def parcel_detail
    @parcel = TradingParcel.find(params[:id])
    @history = Transaction.where(description: @parcel.description).where.not(buyer_id: current_customer.id).order(created_at: :desc).limit(3)
    @data = [['OCT', 10], ['NOV', 15]]
    if params[:proposal] == "true"
      @proposal = Proposal.new
      respond_to do |format|
        format.js { render 'parcel_detail_modal'}
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def related_seller
    @parcels = @parcel.related_parcels(current_customer)
  end

  def parcel_history
    networks = BrokerRequest.where(broker_id: current_customer.id, accepted: true).map { |e| e.seller_id }
    @past_demands = Demand.where(description: @parcel.description, customer_id: networks)
    @past_sell = TradingParcel.where(description: @parcel.description, customer_id: networks, sold: false)
  end

  def direct_sell
    @my_parcel = TradingParcel.find(params[:id])
    @parcel = TradingParcel.new
    @parcel.build_my_transaction
  end

  private
  def trading_parcel_params
    params.require(:trading_parcel).permit(:customer_id, :credit_period, :lot_no, :description, :no_of_stones, :weight, :price, :source, :box, :cost, :box_value, :sight, :percent)
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