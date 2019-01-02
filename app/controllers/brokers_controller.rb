class BrokersController < ApplicationController
  before_action :authenticate_customer!
  before_action :check_record_exit?, only: [:send_request]
  before_action :check_authorization, except: [:reject, :accept, :remove, :requests, :index, :send_request]
  before_action :load_request, only: [:accept, :reject, :remove]

  def index
    @sellers = Company.get_sellers
    @brokers = Company.get_brokers
  end

  def dashboard
    @parcels = TradingParcel.all.select { |e| e.broker_ids.include? current_company.id.to_s unless e.broker_ids.nil? }
  end

  def send_request
    if current_company.is_broker?
      broker_request = BrokerRequest.where(broker_id: current_company.id,
                                           seller_id: params[:s],
                                           sender_id: current_company.id,
                                           receiver_id: params[:s]).first_or_initialize do |br|
        br.accepted = false
      end
    else
      broker_request = BrokerRequest.where(broker_id: params[:s],
                                           seller_id: current_company.id,
                                           sender_id: current_company.id,
                                           receiver_id: params[:s]).first_or_initialize do |br|
        br.accepted = false
      end
    end
    if broker_request.save
      Message.create_new_broker(broker_request, current_company) if current_company.is_broker?
      Message.create_new_seller(broker_request, current_company) unless current_company.is_broker?
      flash[:notice] = 'Request sent successfully.'
      redirect_to brokers_path
    else
      flash[:notice] = 'Unable to send request.'
      redirect_to brokers_path
    end
  end

  def requests
    if current_company.is_broker?
      @requests = BrokerRequest.where(broker_id: current_company.id,
                                      accepted: false,
                                      receiver_id: current_company.id)
      @my_brokers = BrokerRequest.where(broker_id: current_company.id,
                                        accepted: true)
    else
      @requests = BrokerRequest.where(seller_id: current_company.id,
                                      accepted: false,
                                      receiver_id: current_company.id)
      @my_brokers = BrokerRequest.where(seller_id: current_company.id,
                                        accepted: true)
    end
  end

  def accept
    @broker_request.update_column(:accepted, true)
    flash[:notice] = 'Request accepted successfully.'
    redirect_to requests_brokers_path
  end

  def reject
    @broker_request.destroy
    flash[:notice] = 'Request rejected successfully.'
    redirect_to requests_brokers_path
  end

  def remove
    @broker_request.destroy
    CustomerMailer.remove_broker_mail(@broker_request).deliver
    flash[:notice] = 'Broker removed successfully.'
    redirect_to requests_brokers_path
  end

  def shared_parcels
    @parcels = TradingParcel.all.select { |e| e.broker_ids.include? current_customer.id.to_s unless e.broker_ids.nil? }
  end

  def invite
    @broker_invite = BrokerInvite.new
  end

  def send_invite
    @broker_invite = BrokerInvite.new(broker_invite_params)
    if @broker_invite.save
      CustomerMailer.broker_invite_email(@broker_invite).deliver rescue logger.info "Error sending email"
      flash[:success] = "Invite sent successfully"
      redirect_to dashboard_brokers_path
    else
      render :invite
    end
  end

  def demand
    @parcel = TradingParcel.find(params[:id])
    @demand = Demand.where(description: @parcel.description, block: false).where.not(company_id: current_company.id)
  end

  private

  def load_request
    @broker_request = BrokerRequest.find(params[:id])
  end

  def broker_invite_params
    params.require(:broker_invite).permit(:email, :customer_id)
  end

  def check_authorization
    if current_customer.has_role?('Broker')
      # do nothing
    else
      redirect_to trading_customers_path, notice: 'You are not authorized.'
    end
  end

  def check_record_exit?
    if current_company.is_broker?
      request = BrokerRequest.find_by(seller_id: params[:s], broker_id: current_company.id)
    else
      request = BrokerRequest.find_by(seller_id: current_company.id, broker_id: params[:s])
    end
    if request.present?
      flash[:notice] = 'You both are already connected.' if request.accepted?
      flash[:notice] = 'status is already requested.' unless request.accepted?
      redirect_to requests_brokers_path
    end
  end
end



