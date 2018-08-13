module Api
  module V1
    class TradingParcelsController <ApiController
      skip_before_action :verify_authenticity_token, only: [:create, :update ]

      def create
        if current_company
          parcel = TradingParcel.new(parcel_params)
          parcel.company_id = current_company.id
          parcel.customer_id = current_customer.id
          parcel.weight = params[:trading_parcel][:carats]
          parcel.box_value = params[:trading_parcel][:discount]
          parcel.price = params[:trading_parcel][:avg_price]
          parcel.no_of_stones = 0 if params[:trading_parcel][:no_of_stones].blank? || params[:trading_parcel][:no_of_stones].nil?
          if parcel.save
            render json: { success: true, message: 'Parcel created successfully' }
          else
            render json: { success: false, errors: parcel.errors.full_messages, response_code: 200 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def update
        if current_customer
          parcel = TradingParcel.find(params[:id])
          parcel.weight = params[:trading_parcel][:carats]
          parcel.box_value = params[:trading_parcel][:discount]
          parcel.price = params[:trading_parcel][:avg_price]
          parcel.no_of_stones = 0 if params[:trading_parcel][:no_of_stones].blank? || params[:trading_parcel][:no_of_stones].nil?
          if parcel.update_attributes(parcel_params)
            render json: { success: true, message: 'Parcel updated successfully', response_code: 200 }
          else
            render json: { success: false, errors: parcel.errors.full_messages }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def show
        if current_customer
          parcel = TradingParcel.where(id: params[:id]).first
          if parcel.nil?
            render json: { sucess: false, message: 'Parcel not found' }
          else
            render json: { success: true, parcel: parcel_data(parcel), response_code: 200 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def index
        if current_customer
          parcels = current_company.trading_parcels.where(sold: false)
          render json: { success: true, parcels: list_parcel_data(parcels), response_code: 200 }
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      private
      def parcel_params
        params.require(:trading_parcel).permit(:company_id, :customer_id, :credit_period, :lot_no, :diamond_type, :description, :no_of_stones, :weight, :source, :box, :cost, :box_value, :sight, :percent, :comment, :total_value,
                                              parcel_size_infos_attributes: [:id, :carats, :percent, :size, :_destroy ])
      end

      def parcel_data(parcel)
        # available_customers = get_available_buyers(parcel, current_customer)
        # not_enough_available_customers = get_unavailable_buyers(parcel, current_customer)
        # demanded_but_not_available = get_demanded_but_not_available_buyers(parcel, current_customer)
        demanded_clients = []
        all_demanded_clients = get_demanded_clients(parcel, current_company)
        all_demanded_clients.each do |client|
          @data = {
            id: client.id,
            name: client.name,
            city: client.city,
            country: client.county,
            created_at: client.created_at,
            updated_at: client.updated_at,
            is_anonymous: client.is_anonymous,
            add_polished: client.add_polished,
            is_broker: client.is_broker
          }
          demanded_clients << @data
        end
        @info = []
        parcel.parcel_size_infos.each do |i|
          size = i.size.to_f
          per = i.percent.to_f
          @info << { size: size, percent: per }
        end
        respose_hash =  {
          id: parcel.id.to_s,
          description: parcel.description,
          lot_no: parcel.lot_no,
          no_of_stones: parcel.no_of_stones,
          carats: parcel.try(:weight).to_f,
          credit_period: parcel.credit_period,
          avg_price: parcel.try(:price).to_f,
          company: parcel.try(:company).try(:name),
          cost: parcel.cost,
          discount_per_month: parcel.box_value,
          sight: parcel.sight,
          source: parcel.source,
          uid: parcel.uid,
          percent:  parcel.try(:percent).to_f,
          comment: parcel.comment.to_s,
          total_value: parcel.try(:total_value).to_f,
          size_info: @info,
          vital_sales_data: {
            demanded_clients: demanded_clients
          }
        }
      end

      def customers_data(customers)
        @data = []
        customers.each do |c|
          @data << {
            id: c.id.to_s,
            name: c.try(:name),
            total_limit: get_credit_limit(c, current_company),
            used_limit: get_used_credit_limit(c, current_company),
            available_limit: get_available_credit_limit(c, current_company),
            overdue_limit: get_days_limit(c, current_company),
            market_limit: get_market_limit_from_credit_limit_table(c, current_company).to_s,
            supplier_connected: supplier_connected(c, current_company).to_s
          }
        end
        @data
      end

      def list_parcel_data(parcels)
        @data = []
        parcels.each do |parcel|
          total_value = parcel.total_value.nil? ? nil : '%.2f' % parcel.total_value
          @data << { id: parcel.id.to_s, description: parcel.description, total_value: total_value }
        end
        @data
      end
    end
  end
end
