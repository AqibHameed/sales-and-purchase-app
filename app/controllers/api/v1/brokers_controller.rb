module Api
  module V1
    class BrokersController < ApiController
      before_action :check_current_company_requests , only: [:accept, :reject, :remove]
      skip_before_action :verify_authenticity_token, only: [:send_request, :company_record_on_the_basis_of_roles, :accept, :reject, :remove]

      include ApplicationHelper

      def index
        @sellers = Company.get_sellers
        @data = []
        @sellers.each do |s|
          @data << {
            id: s.id,
            name: s.name
          }
        end
        @all_sellers = Kaminari.paginate_array(@data).page(params[:page]).per(params[:count])
        render json: { success: true, pagination: set_pagination(:all_sellers), sellers: @all_sellers }
      end

=begin
  @apiVersion 1.0.0
  @api {get} /api/v1/brokers/company_record_on_the_basis_of_roles
  @apiSampleRequest off
  @apiName company_record_on_the_basis_of_roles
  @apiGroup Brokers
  @apiDescription get company record on the basis of roles
  @apiSuccessExample {json} SuccessResponse:
  {
    "success": true,
    "pagination": {
        "total_pages": 1,
        "prev_page": null,
        "next_page": null,
        "current_page": 1
    },
    "company_record_on_the_basis_of_roles": [
        {
            "id": 2,
            "name": "Buyer B",
            "status": "SendRequest"
        },
        {
            "id": 3,
            "name": "Buyer C",
            "status": "SendRequest"
        },
        {
            "id": 5,
            "name": "Seller B",
            "status": "SendRequest"
        },
        {
            "id": 6,
            "name": "Seller C",
            "status": "SendRequest"
        },
        {
            "id": 7,
            "name": "Dummy Buyer 1",
            "status": "SendRequest"
        },
        {
            "id": 8,
            "name": "Dummy Seller 1",
            "status": "SendRequest"
        },
        {
            "id": 9,
            "name": "Dummy Seller 2",
            "status": "SendRequest"
        },
        {
            "id": 10,
            "name": "Dummy Buyer 2",
            "status": "SendRequest"
        }
    ]
  }
=end
      def company_record_on_the_basis_of_roles
        @data = []
        if current_company.is_broker?
          @brokers = Company.get_brokers
          @brokers.each do |b|
            @data << {
                id: b.id,
                name: b.name,
                status: check_request_seller(current_company, b)
               # status:
            }
          end
        else
          @sellers = Company.get_sellers
          @sellers.each do |s|
            @data << {
                id: s.id,
                name: s.name,
                status: check_request_broker(current_company, s)
            }
          end
        end
        @all_company_record_on_the_basis_of_roles = Kaminari.paginate_array(@data).page(params[:page]).per(params[:count])
        render json: { success: true, pagination: set_pagination(:all_company_record_on_the_basis_of_roles), company_record_on_the_basis_of_roles: @all_company_record_on_the_basis_of_roles }
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/brokers/assigned_parcels
 @apiSampleRequest off
 @apiName assigned parcels
 @apiGroup Brokers
 @apiDescription assign parcels to the broker
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "parcels": []
}
=end

      def assigned_parcels
        if current_company
          @data = []
          @parcels = TradingParcel.all.select { |e| e.broker_ids.include? current_company.id.to_s unless e.broker_ids.nil? }
          @parcels.each do |p|
            @data << {
              id: p.id,
              description: p.description
            }
          end
          render json: { success: true, parcels: @data }
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/brokers/send_request
 @apiSampleRequest off
 @apiName Send request
 @apiGroup Brokers
 @apiDescription send request seller to broker, broker to seller
 @apiParamExample {json} Request-Example:
{
	"company": "broker1(Broker)"
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": "Request sent successfully"
}
=end

      def send_request
        if current_company
          company = Company.where("name LIKE ?", params[:company]).first
          if company.present?
            if current_company.is_broker?
              request = BrokerRequest.where(broker_id: current_company.id,
                                                   seller_id: company.id,
                                                   sender_id: current_company.id,
                                                   receiver_id: company.id).first_or_initialize do |br|
                br.accepted = false
              end
            else
              request = BrokerRequest.where(broker_id: company.id,
                                                   seller_id: current_company.id,
                                                   sender_id: current_company.id,
                                                   receiver_id: company.id).first_or_initialize do |br|
                br.accepted = false
              end
            end
            if request.save
              Message.create_new_broker(request, current_company) if current_company.is_broker?
              Message.create_new_seller(request, current_company) unless current_company.is_broker?
              render json: {success: true, message: "Request sent successfully"}
            else
              render json: {success: false, message: "Unable to send request."}
            end
          else
            render json: {success: false, message: "There is no company with this name"}
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end

      def demanding_companies
        @data = []
        if current_company
          @parcel = TradingParcel.where(id: params[:id]).first
          if @parcel.present?
            @demand = Demand.where(description: @parcel.description, block: false).where.not(company_id: current_company.id)
            if @demand.present?
              all_companies = @demand.map{|d| d.company}
              all_companies.each do |company|
                @data << {
                  id: company.id,
                  name: company.name
                }
              end
              render json: { success: true, companies: @data }
            else
              render json: { success: false, message: "This parcel is not demanded" }
            end
          else 
            render json: { success: false, message: "Parcel for this id does not present." }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/brokers/accept
 @apiSampleRequest off
 @apiName Accept request
 @apiGroup Brokers
 @apiDescription accept request seller to broker or broker to seller
 @apiParamExample {json} Request-Example:
{
	"request_id": 3
}
 @apiSuccessExample {json} SuccessResponse:
{
  success: true,
  message: 'Request accepted successfully.',
  status: 200
}
=end

      def accept
        render json: { success: true,
                       message: 'Request accepted successfully.',
                       response_code: 200 } if @broker_request.update_column(:accepted, true)
      end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/brokers/reject
 @apiSampleRequest off
 @apiName reject request
 @apiGroup Brokers
 @apiDescription reject request seller to broker or broker to seller
 @apiParamExample {json} Request-Example:
{
	"request_id": 3
}
 @apiSuccessExample {json} SuccessResponse:
{
  success: true,
  message: 'Request rejected successfully.',
  status: 200
}
=end

      def reject
        render json: { success: true,
                       message: 'Request rejected successfully.',
                       response_code: 200 } if @broker_request.destroy
      end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/brokers/remove
 @apiSampleRequest off
 @apiName remove request
 @apiGroup Brokers
 @apiDescription reomve  seller or broker
 @apiParamExample {json} Request-Example:
{
	"request_id": 3
}
 @apiSuccessExample {json} SuccessResponse:
{
  success: true,
  message: 'You have removed successfully.',
  status: 200
}
=end

      def remove
        if @broker_request.destroy
          CustomerMailer.remove_broker_mail(@broker_request).deliver
          render json: { success: true,
                         message: 'You have removed successfully.',
                         response_code: 200 }
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/brokers/show_requests
 @apiSampleRequest off
 @apiName show requests
 @apiGroup Brokers
 @apiDescription show requests incoming from sellers/buyers or broker
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "pagination": {
        "total_pages": 1,
        "prev_page": null,
        "next_page": null,
        "current_page": 1
    },
    "response_code": 200,
    "requests": [
        {
            "request_id": 8,
            "broker_name": "broker 1",
            "seller_buyer_name": "broker1(Broker)"
        }
    ]
}
=end

      def show_requests
        if current_company
          @requests_data = []
          if current_company.is_broker?
            @requests = BrokerRequest.where(broker_id: current_company.id,
                                            accepted: false,
                                            receiver_id: current_company.id)
            @requests.each do |request|
              @requests_data << {
                  request_id: request.id,
                  seller_buyer_name: request.seller.customers.first.name,
                  broker_name: request.seller.name
              }
            end unless @requests.nil?
          else
            @requests = BrokerRequest.where(seller_id: current_company.id,
                                            accepted: false,
                                            receiver_id: current_company.id)
            @requests.each do |request|
              @requests_data << {
                  request_id: request.id,
                  broker_name: request.broker.customers.first.name,
                  seller_buyer_name: request.broker.name
              }
            end unless @requests.nil?
          end
          @all_requests = Kaminari.paginate_array(@requests_data).page(params[:page]).per(params[:count])
          render json: { success: true,
                         pagination: set_pagination(:all_requests),
                         response_code: 200,
                         requests: @requests_data}
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/brokers/show_myclients
 @apiSampleRequest off
 @apiName show all connected sellers/buyers or brokers
 @apiGroup Brokers
 @apiDescription show connected sellers/buyers or broker
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "pagination": {
        "total_pages": 1,
        "prev_page": null,
        "next_page": null,
        "current_page": 1
    },
    "response_code": 200,
    "myclients": [
        {
            "request_id": 9,
            "broker_name": "broker 1",
            "seller_buyer_name": "broker1(Broker)"
        }
    ]
}
=end

      def show_myclients
        if current_company
          @my_clients_data = []
          if current_company.is_broker?
            @my_sellers = BrokerRequest.where(broker_id: current_company.id,
                                              accepted: true)
            @my_sellers.each do |mysellers|
              @my_clients_data << {
                  request_id: mysellers.id,
                  seller_buyer_name: mysellers.brokers.customers.first.name,
                  broker_name: mysellers.brokers.name
              }
            end unless @my_sellers.nil?
          else
            @my_brokers = BrokerRequest.where(seller_id: current_company.id,
                                              accepted: true)
            @my_brokers.each do |mybroker|
              @my_clients_data << {
                  request_id: mybroker.id,
                  broker_name: mybroker.broker.customers.first.name,
                  seller_buyer_name: mybroker.broker.name
              }
            end unless @my_brokers.nil?
          end
          @all_clients = Kaminari.paginate_array(@my_clients_data).page(params[:page]).per(params[:count])
          render json: { success: true,
                         pagination: set_pagination(:all_clients),
                         response_code: 200,
                         myclients: @my_clients_data }
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      private

      def check_current_company_requests
        if current_company
          @broker_request = BrokerRequest.find_by(id: params[:request_id], receiver_id: current_company.id)
          if @broker_request.nil?
            render json: { success: true, message: "#{current_company.name} don't have any request with this id #{params[:request_id]}" }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

    end
  end
end