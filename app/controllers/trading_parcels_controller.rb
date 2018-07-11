class TradingParcelsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include ApplicationHelper

  before_action :authenticate_customer!
  # before_action :authenticate_admin!
  before_action :is_user_edit_polished?, only: [:edit]
  before_action :check_role_authorization, except: [:related_seller, :parcel_history]
  before_action :set_trading_parcel, only: [:show, :edit, :update, :destroy, :direct_sell, :save_direct_sell, :check_authenticate_supplier, :related_seller, :parcel_history, :size_info, :check_for_sale]
  before_action :check_authenticate_supplier, only: [:edit, :update, :destroy]
  before_action :authenticate_broker, only: [:related_seller, :parcel_history]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'Parcel not found'
    redirect_to suppliers_path
  end

  def create
    check_broker = true
    @parcel = TradingParcel.new(trading_parcel_params)
    if params[:trading_parcel][:no_of_stones] == ''
      @parcel.no_of_stones = 0
    end
    if trading_parcel_params[:sale_broker].to_i == 1 && trading_parcel_params[:broker_ids].blank?
      check_broker = false
    end

    if @parcel.save && check_broker
      flash[:notice] = "Parcel created successfully"
      respond_to do |format|
        format.js {render :js => "window.location.href='"+single_parcel_supplier_path(@parcel)+"'"}
        format.html { redirect_to single_parcel_supplier_path(@parcel) }
      end
    else
      check_broker ? '' : @parcel.errors.add(:broker_ids, "can't be blank...")
      @trading_parcel = @parcel
      respond_to do |format|
        format.js
        format.html { redirect_to single_parcel_supplier_path(@parcel) }
      end
    end
  end

  def show
    @proposal = Proposal.new
    @info = []
    @available_customers = get_available_buyers(@parcel, current_customer)
    @not_enough_available_customers = get_unavailable_buyers(@parcel, current_customer)
    @demanded_but_not_available = get_demanded_but_not_available_buyers(@parcel, current_customer)
  end

  def edit
  end

  def message
    @message = Message.new
    @company = Company.find(params[:id])
  end

  def update
    check_broker = true
    if trading_parcel_params[:sale_broker].to_i == 1 && trading_parcel_params[:broker_ids].blank?
      check_broker = false
    end
    if @parcel.update_attributes(trading_parcel_params) && check_broker
      flash[:notice] = 'Parcel updated successfully'
      respond_to do |format|
        format.js {render :js => "window.location.href='"+trading_customers_path+"'"}
        format.html { redirect_to trading_customers_path }
      end
    else
      check_broker ? '' : @parcel.errors.add(:broker_ids, "can't be blank...")
      @trading_parcel = @parcel
      respond_to do |format|
        format.js {render :create}
        format.html { redirect_to trading_customers_path }
      end
    end
  end

  def destroy
    @parcel.destroy
    flash[:notice] = 'Parcel deleted successfully'
    redirect_to trading_customers_path
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
    @parcels = @parcel.related_parcels(current_company)
  end

  def parcel_history
    networks = BrokerRequest.where(broker_id: current_company.id, accepted: true).map { |e| e.seller_id }
    @past_demands = Demand.where(description: @parcel.description, company_id: networks)
    @past_sell = TradingParcel.where(description: @parcel.description, company_id: networks, sold: false)
  end

  def direct_sell
    @transaction = Transaction.new
  end

  def save_direct_sell
    @transaction = Transaction.new(buyer_id: params[:transaction][:buyer_id], seller_id: @parcel.company_id, trading_parcel_id: @parcel.id, paid: params[:transaction][:paid],
                                  price: @parcel.price, credit: @parcel.credit_period, diamond_type: @parcel.diamond_type, buyer_confirmed: false, transaction_type: 'manual',
                                  created_at: params[:transaction][:created_at])
    if @transaction.save
      @transaction.set_due_date
      @parcel.update_attributes(sold: true)
      @trading_parcel = @parcel.dup
      @trading_parcel.company_id = @transaction.buyer_id
      @trading_parcel.sold = false
      @trading_parcel.sale_all = false
      @trading_parcel.save
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

  def check_for_sale
    @parcel.update(parcel_visibility_params)
    (parcel_visibility_params[:sale_broker].to_i == 1) ? update_broker(params[:broker_id]) : update_broker(nil)
    respond_to do |format|
      format.js { render js: "$('#for_sale_modal').modal('hide')"}
    end
  end

  def update_broker(broker_ids)
    @parcel.update_column(:broker_ids, broker_ids)
  end

  private
  def trading_parcel_params
    params.require(:trading_parcel).permit(:company_id, :customer_id, :credit_period, :lot_no, :diamond_type, :description, :no_of_stones, :weight, :price, :source, :box, :cost, :box_value, :sight, :percent, :comment, :total_value, :sale_all, :sale_none, :sale_broker, :sale_credit, :sale_demanded, :broker_ids, :anonymous, :shape, :color, :clarity, :cut, :polish, :symmetry, :fluorescence, :lab, :city, :country,
                                              parcel_size_infos_attributes: [:id, :carats, :percent, :size, :_destroy ])

  end

  def set_trading_parcel
    @parcel = TradingParcel.find(params[:id])
  end

  def parcel_visibility_params
    params[:trading_parcel].permit!
  end

  def check_authenticate_supplier
    if current_customer.company.id == @parcel.company_id
    else
      flash[:notice] = 'You are not authorized for this action'
      redirect_to trading_customers_path
    end
  end

  def authenticate_broker
    if current_customer.has_role?('Broker')
      # do nothing
    else
      redirect_to trading_customers_path, notice: 'You are not authorized.'
    end
  end

  def is_user_edit_polished?
    unless current_company.add_polished
      redirect_to trading_customers_path, notice: 'Please contact admin, permission denied...'
    end
  end

end