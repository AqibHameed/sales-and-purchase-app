class BrokersController < ApplicationController

  def index
    @sellers = Customer.get_sellers
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
    request = BrokerRequest.find(params[:id])
    request.update_column(:accepted, true)
    flash[:notice] = 'Request accepted successfully.'
    redirect_to requests_brokers_path
  end

  def reject
    request = BrokerRequest.find(params[:id])
    request.destroy
    flash[:notice] = 'Request rejected successfully.'
    redirect_to requests_brokers_path
  end
end
    