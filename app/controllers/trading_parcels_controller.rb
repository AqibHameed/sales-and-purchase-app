class TradingParcelsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include ApplicationHelper

  before_action :authenticate_customer!
  # before_action :authenticate_admin!
  before_action :set_trading_parcel, only: [:show, :edit, :update, :destroy, :direct_sell, :save_direct_sell, :check_authenticate_supplier, :share_broker, :related_seller, :parcel_history, :size_info]
  before_action :check_authenticate_supplier, only: [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'Parcel not found'
    redirect_to suppliers_path
  end

  def create
    @parcel = TradingParcel.new(trading_parcel_params)
    if params[:trading_parcel][:no_of_stones] == ''
      @parcel.no_of_stones = 0
    end
    if @parcel.save
      # @parcel.update_column(:diamond_type, params[:trading_document_diamond_type])
      flash[:notice] = "Parcel created successfully"
      if params[:trading_parcel][:single_parcel].present?
        respond_to do |format|
          format.js {render :js => "window.location.href='"+single_parcel_supplier_path(@parcel)+"'"}
        end
      else
        respond_to do |format|
          format.js {render :js => "window.location.href='"+trading_customers_path+"'"}
        end
      end
    else
      @trading_parcel = @parcel
      respond_to do |format|
        format.js
      end
    end
  end

  def show
    @proposal = Proposal.new
    @info = []
    @available_customers = []
    available_customers = []
    @not_enough_available_customers = []
    not_enough_available_customers = []
    @demanded_but_not_available = []
    demanded_but_not_available = []
    flag1 = []
    flag2 = []
    flag3 = []
    customers = CreditLimit.where(seller_id: current_customer.id).map { |e|  e.buyer  }
    customers.each do |c|
      if get_available_credit_limit(c, current_customer).to_f >= @parcel.price.to_f
        if CreditLimit.where(buyer_id: c.id, seller_id: current_customer.id, star: true).first.present?
          available_customers << c
        else
          flag1 << c
        end
      elsif get_available_credit_limit(c, current_customer).to_f < @parcel.price.to_f
        if CreditLimit.where(buyer_id: c.id, seller_id: current_customer.id, star: true).first.present?
          not_enough_available_customers << c
        else
          flag2 << c
        end
      end
    end
    @available_customers = available_customers + flag1
    @available_customers = @available_customers.uniq
    @not_enough_available_customers = not_enough_available_customers + flag2
    @not_enough_available_customers = @not_enough_available_customers.uniq

    demands = Demand.where(description: @parcel.description).map { |e|  e.customer  }
    demands.each do |customer|
      if !customer.buyer_credit_limits.where(seller_id: current_customer.id).present?
        if CreditLimit.where(buyer_id: customer.id, seller_id: current_customer.id, star: true).first.present?
          demanded_but_not_available << customer
        else
          flag3 << customer
        end
      end
    end
    @demanded_but_not_available = demanded_but_not_available + flag3
    @demanded_but_not_available = @demanded_but_not_available.uniq
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
    @info = []
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
    # @my_parcel = TradingParcel.find(params[:id])
    @transaction = Transaction.new
  end

  def save_direct_sell
    @transaction = Transaction.new(buyer_id: params[:transaction][:buyer_id], seller_id: @parcel.customer_id, trading_parcel_id: @parcel.id, paid: params[:transaction][:paid],
                                  price: @parcel.price, credit: @parcel.credit_period, diamond_type: @parcel.diamond_type, buyer_confirmed: false, transaction_type: 'manual',
                                  created_at: params[:transaction][:created_at])
    if @transaction.save
      @transaction.set_due_date
      @parcel.update_attributes(sold: true)
      redirect_to trading_customers_path, notice: 'Transaction added successfully'
    else
      render :direct_sell
    end
  end

  def size_info
    @info = @parcel.parcel_size_infos
    respond_to do |format|
      format.js
    end
  end

  private
  def trading_parcel_params
    params.require(:trading_parcel).permit(:customer_id, :credit_period, :lot_no, :diamond_type, :description, :no_of_stones, :weight, :price, :source, :box, :cost, :box_value, :sight, :percent, :comment, :total_value,
                                              parcel_size_infos_attributes: [:id, :carats, :percent, :size, :_destroy ])

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