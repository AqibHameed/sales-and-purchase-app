class BrokersController < ApplicationController
  before_action :load_request, only: [:accept, :reject, :remove]

  def index
    @sellers = Customer.get_sellers
  end

  def dashboard
    @parcels = TradingParcel.all.select { |e| e.broker_ids.include? current_customer.id.to_s unless e.broker_ids.nil? }
  end

  def send_request
    broker_request = BrokerRequest.where(broker_id: current_customer.id, seller_id: params[:s]).first_or_initialize do |br|
      br.accepted = false
    end
    if broker_request.save
      Message.create_new_broker(broker_request, current_customer)
      flash[:notice] = 'Request sent successfully.'
      redirect_to brokers_path
    else
      flash[:notice] = 'Unable to send request.'
      redirect_to brokers_path
    end
  end

  def requests
    @requests = BrokerRequest.where(seller_id: current_customer.id, accepted: false)
    @my_brokers = BrokerRequest.where(seller_id: current_customer.id, accepted: true)
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
    puts @broker_request.inspect
    @broker_request.destroy
    CustomerMailer.remove_broker_mail(@broker_request).deliver
    flash[:notice] = 'Broker removed successfully.'
    redirect_to requests_brokers_path
  end

  def shared_parcels
    @parcels = TradingParcel.all.select { |e| e.broker_ids.include? current_customer.id.to_s unless e.broker_ids.nil? }
  end

  private

  def load_request
    @broker_request = BrokerRequest.find(params[:id])
  end
end
    