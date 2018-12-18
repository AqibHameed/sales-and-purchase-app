module Api
  module V1
    class BrokersController < ApiController
      before_action :load_request , only: [:reject, :remove]
      skip_before_action :verify_authenticity_token, only: [:send_request]

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

      def send_request
        if current_company
          seller = Company.where("name LIKE ?", params[:company]).first
          if seller.present?
            broker_request = BrokerRequest.where(broker_id: current_company.id, seller_id: seller.id).first_or_initialize do |br|
              br.accepted = false
            end
            if broker_request.save
              Message.create_new_broker(broker_request, current_company)
              render json: { success: true, message: "Request sent successfully" }
            else
              render json: { success: false, message: "Unable to send request." }
            end
          else
            render json: { success: false, message: "There is no company with this name" }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
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
    end

    private

    def load_request
      @broker_request = BrokerRequest.find(params[:id])
    end
  end
end