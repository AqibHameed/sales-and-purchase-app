class TradingParcelsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include ApplicationHelper

  before_action :authenticate_customer!
  # before_action :authenticate_admin!
  before_action :check_role_authorization, except: [:related_seller, :parcel_history]
  before_action :set_trading_parcel, only: [:show, :edit, :update, :destroy, :accept_transaction, :check_authenticate_supplier, :related_seller, :parcel_history, :size_info, :remove_direct_parcel, :check_for_sale]
  before_action :check_authenticate_supplier, only: [:edit, :update, :destroy]
  before_action :authenticate_broker, only: [:related_seller, :parcel_history]
  before_action :is_user_edit_polished?, only: [:edit]

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
      @parcel.send_mail_to_demanded
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
    @demanded_clients = get_demanded_clients(@parcel, current_company)
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
    @trading_parcel = TradingParcel.new
    @trading_parcel.build_my_transaction
  end

  def save_direct_sell
    if params[:check].present?
      if params[:check] == 'true'
        if params[:check_transactions].present? 
          @parcel = TradingParcel.find_by(id: params[:id])
        else
          @parcel = TradingParcel.create(trading_parcel_params)
          @parcel.update(sold: true)
        end
      else
        @parcel = TradingParcel.find_by(id: params[:id])
      end
    else
      if params[:market_limit] == 'true'
        @parcel = TradingParcel.find_by(id: params[:id])
      end
    end
    transaction = Transaction.new(buyer_id: params[:trading_parcel][:my_transaction_attributes][:buyer_id], seller_id: @parcel.try(:company_id), trading_parcel_id: @parcel.id, paid: params[:trading_parcel][:my_transaction_attributes][:paid],
                                    price: @parcel.try(:price), credit: @parcel.try(:credit_period), diamond_type: @parcel.try(:diamond_type), transaction_type: 'manual',
                                    created_at: params[:trading_parcel][:my_transaction_attributes][:created_at])

    buyer =  Company.where(id: transaction.buyer_id).first
    registered_users = Company.where(id: params[:trading_parcel][:my_transaction_attributes][:buyer_id]).first.customers.count
    if transaction.paid == true
      save_transaction(transaction, @parcel)
    elsif params[:check].present? && params[:check] == "true"
      if registered_users < 1
        if params[:trading_parcel][:my_transaction_attributes][:created_at].to_date < Date.today
          save_transaction(transaction, @parcel)
        else
          if buyer.buyer_transactions.count < 1
            if params[:check_transactions].present? && params[:check_transactions] == "true"
              check_overdue_and_market_limit(transaction, @parcel)
            elsif params[:check_transactions].present? && params[:check_transactions] == "false"
            else
              respond_to do |format|
                format.js { render 'check_unregistered_transaction.js.erb', locals: {price: @parcel.total_value, buyer_id: transaction.buyer_id, created_at: transaction.created_at, paid: transaction.paid, parcel_id: @parcel.id}}
              end
            end
          else
            check_overdue_and_market_limit(transaction, @parcel)
          end
        end
      else
        check_credit_limit(transaction, @parcel)
      end
    elsif params[:market_limit].present? && params[:market_limit] == "true"
      check_credit_limit(transaction, @parcel)
    else
      save_transaction(transaction, @parcel)
    end
  end

  def remove_direct_parcel
    @parcel.destroy
  end

  def save_transaction(transaction, parcel)
    buyer = Company.where(id: transaction.buyer_id).first
    available_credit_limit = get_available_credit_limit(transaction.buyer, current_company).to_f
    if transaction.save
      if transaction.buyer.customers.count < 1
        CustomerMailer.unregistered_users_mail_to_company(current_customer, current_company.name, transaction).deliver rescue logger.info "Error sending email"
      else
        CustomerMailer.mail_to_registered_users(current_customer, current_company.name, transaction).deliver rescue logger.info "Error sending email"
      end
      all_user_ids = transaction.buyer.customers.map{|c| c.id}.uniq
      current_company.send_notification('New Direct Sell', all_user_ids)
      transaction.set_due_date
      transaction.generate_and_add_uid
      ## set limit ##
      total_price = parcel.total_value
      credit_limit = CreditLimit.where(buyer_id: transaction.buyer_id, seller_id: current_company.id).first
      if available_credit_limit < total_price
        if credit_limit.nil?
          credit_limit = CreditLimit.create(buyer_id: transaction.buyer_id, seller_id: current_company.id, credit_limit: total_price)
        else
          new_limit = credit_limit.credit_limit + (total_price - available_credit_limit)
          credit_limit.update_attributes(credit_limit: new_limit)
        end
      end
      used = get_market_limit(buyer, current_company).to_f
      market_limit =  get_market_limit_from_credit_limit_table(buyer, current_company).to_f
      if total_price > market_limit
        new_market_limit = total_price - (market_limit - used) + market_limit
        credit_limit.update_attributes(market_limit: new_market_limit)
      end
      parcel.update_attributes(sold: true)
      redirect_to trading_customers_path, notice: 'Transaction added successfully'
    else
      @transaction = transaction
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

  def historical_polished
    trading_parcels = TradingParcel.where(historical_params)
    if trading_parcels.empty?
      sum_of_five_transaction = 'Not enough data'
      last_transaction_amt = 'Not enough data'
    else
      @all_transactions = []
      trading_parcels.each do |parcel|
        @all_transactions << parcel.parcel_transactions
      end
      # Add order
      @all_transactions = @all_transactions
      last_transaction = @all_transactions.first.last
      last_transaction_amt = last_transaction.total_amount

      last_five_transactions = @all_transactions.last(5)
      if last_five_transactions.count < 5
        sum_of_five_transaction = 'Not enough data'
      else
        sum_of_five_transaction = last_five_transactions.map(&:total_amount).try(:sum) rescue 0
        sum_of_five_transaction = sum_of_five_transaction/5
      end
    end
    respond_to do |format|
      format.js { render json: { sum_of_five_transaction: sum_of_five_transaction, last_transaction: last_transaction_amt }}
    end
  end

  private
  def trading_parcel_params
    params.require(:trading_parcel).permit(:company_id, :customer_id, :credit_period, :lot_no, :diamond_type, :description, :no_of_stones, :weight, :price, :source, :box, :cost, :box_value, :sight, :percent, :comment, :total_value, :sale_all, :sale_none, :sale_broker, :sale_credit, :sale_demanded, :broker_ids, :anonymous, :shape, :color, :clarity, :cut, :polish, :symmetry, :fluorescence, :lab, :city, :country, :size,
                                              parcel_size_infos_attributes: [:id, :carats, :percent, :size, :_destroy ])
  end

  def historical_params
    params[:data].merge({sold: true})
    params.require(:data).permit!
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
    if @parcel.source == 'POLISHED'
      unless current_company.add_polished
        redirect_to trading_customers_path, notice: 'Please contact admin, permission denied...'
      end
    end
  end


  def check_credit_limit(transaction, parcel)
    buyer = Company.where(id: transaction.buyer_id).first
    credit_limit = get_available_credit_limit(buyer, current_company).to_f
    used  =  get_used_credit_limit(buyer, current_company).to_f
    if credit_limit < parcel.total_value.to_f
      respond_to do |format|
        format.js { render 'save_direct_sell.js.erb', locals: {price: parcel.total_value, buyer_id: transaction.buyer_id, created_at: transaction.created_at, paid: transaction.paid, parcel_id: parcel.id, available_credit_limit: credit_limit, used_limit: used}}
      end
    else
      save_transaction(transaction, parcel)
    end
  end

  def check_overdue_and_market_limit(transaction, parcel)
    buyer = Company.where(id: transaction.buyer_id).first
    market_limit = CreditLimit.where(seller_id: current_company.id, buyer_id: buyer.id).first
    if (market_limit.present? && market_limit.market_limit.to_f < parcel.total_value.to_f) || current_company.has_overdue_transaction_of_30_days(transaction.buyer_id)     
      respond_to do |format|
        format.js { render 'check_market_overdue_limit.js.erb', locals: { buyer_id: transaction.buyer_id, created_at: transaction.created_at, paid: transaction.paid, parcel_id: parcel.id }}
      end
    else
      check_credit_limit(transaction, parcel)
    end
  end

end