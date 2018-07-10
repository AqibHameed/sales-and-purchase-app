class BrokersController < ApplicationController
  before_action :check_authorization, except: [:reject, :accept, :remove, :requests]
  before_action :load_request, only: [:accept, :reject, :remove]

  def index
    @sellers = Company.get_sellers
  end

  def dashboard
    @parcels = TradingParcel.all.select { |e| e.broker_ids.include? current_company.id.to_s unless e.broker_ids.nil? }
  end

  def send_request
    broker_request = BrokerRequest.where(broker_id: current_company.id, seller_id: params[:s]).first_or_initialize do |br|
      br.accepted = false
    end
    if broker_request.save
      Message.create_new_broker(broker_request, current_company)
      flash[:notice] = 'Request sent successfully.'
      redirect_to brokers_path
    else
      flash[:notice] = 'Unable to send request.'
      redirect_to brokers_path
    end
  end

  def requests
    @requests = BrokerRequest.where(seller_id: current_company.id, accepted: false)
    @my_brokers = BrokerRequest.where(seller_id: current_company.id, accepted: true)
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
      CustomerMailer.broker_invite_email(@broker_invite).deliver #rescue logger.info "Error sending email"
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
end



