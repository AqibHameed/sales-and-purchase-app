module Api
  module V1
    class TradingParcelsController <ApiController
      skip_before_action :verify_authenticity_token, only: [:create, :update, :direct_sell, :destroy]

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

      def destroy
        @parcel = TradingParcel.where(id: params[:id]).first
        if @parcel.present?
          if @parcel.destroy
            render json: { success: true, message: "This parcel is deleted successfully." }
          else
            render json: { errors: @parcel.errors.full_messages }
          end
        else
          render json: { errors: 'Parcel does not exist.' }
        end
      end

      def direct_sell
        if current_customer
          @parcel = TradingParcel.new(trading_parcel_params)
          @parcel.company_id = current_company.id
          @parcel.customer_id = current_customer.id
          @parcel.weight = params[:trading_parcel][:carats]
          @parcel.box_value = params[:trading_parcel][:discount]
          @parcel.sold = true
          if @parcel.save
            transaction = Transaction.new(buyer_id: params[:trading_parcel][:my_transaction_attributes][:buyer_id], seller_id: @parcel.try(:company_id), trading_parcel_id: @parcel.id, paid: params[:trading_parcel][:my_transaction_attributes][:paid],
                                            price: @parcel.try(:price), credit: @parcel.try(:credit_period), diamond_type: @parcel.try(:diamond_type), transaction_type: 'manual',
                                            created_at: params[:trading_parcel][:my_transaction_attributes][:created_at])
            buyer =  Company.where(id: params[:trading_parcel][:my_transaction_attributes][:buyer_id]).first
            if buyer.present?
              registered_users = buyer.customers.count
              if transaction.paid == true
                save_transaction(transaction, @parcel)
              elsif params[:available_credit_limit].present? && params[:available_credit_limit] == true
                save_transaction(transaction, @parcel)
              elsif params[:available_credit_limit].present? && params[:available_credit_limit] == false
              elsif params[:available_market_overdue].present? && params[:available_market_overdue] == false
              elsif params[:available_market_overdue].present? && params[:available_market_overdue] == true
                check_credit_limit(transaction, @parcel)
              else
                if registered_users < 1
                  if params[:trading_parcel][:my_transaction_attributes][:created_at].present? && (params[:trading_parcel][:my_transaction_attributes][:created_at].to_date < Date.today)
                    save_transaction(transaction, @parcel)
                  else
                    check_overdue_and_market_limit(transaction, @parcel)
                  end
                else
                  check_credit_limit(transaction, @parcel)
                end
              end
            else
              render json: { success: false, message: "Buyer does not present" }
            end
          else
            render json: { success: false, errors: @parcel.errors.full_messages }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def save_transaction(transaction, parcel)
        buyer = Company.where(id: transaction.buyer_id).first
        available_credit_limit = get_available_credit_limit(transaction.buyer, current_company).to_f
        if transaction.save
          transaction.set_due_date
          transaction.generate_and_add_uid
          ## set limit ##
          total_price = parcel.total_value
          credit_limit = CreditLimit.where(buyer_id: transaction.buyer_id, seller_id: current_company.id).first
          if available_credit_limit < total_price
            if credit_limit.nil?
              CreditLimit.create(buyer_id: transaction.buyer_id, seller_id: current_company.id, credit_limit: total_price)
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
          render json: { success: true, notice: 'Transaction added successfully'}
        else
          render json: { success: false, errors: transaction.errors.full_messages }
        end
      end


      private
      def parcel_params
        params.require(:trading_parcel).permit(:company_id, :customer_id, :credit_period, :lot_no, :diamond_type, :description, :no_of_stones, :weight, :source, :box, :cost, :box_value, :sight, :percent, :comment, :total_value,
                                              parcel_size_infos_attributes: [:id, :carats, :percent, :size, :_destroy ])
      end

      def trading_parcel_params
        params.require(:trading_parcel).permit(:description, :source, :sight, :cost, :no_of_stones, :percent, :credit_period, :price, :total_value)
      end

      def parcel_data(parcel)
        # available_customers = get_available_buyers(parcel, current_customer)
        # not_enough_available_customers = get_unavailable_buyers(parcel, current_customer)
        # demanded_but_not_available = get_demanded_but_not_available_buyers(parcel, current_customer)
        demanded_clients = []
        users = []
        all_demanded_clients = get_demanded_clients(parcel, current_company)
        all_demanded_clients.each do |client|
          client.customers.each do |customer|
            details = {
              user_id: customer.id ,
              first_name: customer.first_name,
              last_name: customer.last_name
            }
            users << details
          end
          @data = {
            id: client.id,
            name: client.name,
            city: client.city,
            country: client.county,
            created_at: client.created_at,
            updated_at: client.updated_at,
            is_anonymous: client.is_anonymous,
            add_polished: client.add_polished,
            is_broker: client.is_broker,
            users: users
          }
          demanded_clients << @data
        end
        @info = []
        parcel.parcel_size_infos.each do |i|
          size = i.size
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
          @data << { id: parcel.id.to_s, source: parcel.source, description: parcel.description, total_value: total_value }
        end
        @data
      end

      def check_credit_limit(transaction, parcel)
        buyer = Company.where(id: transaction.buyer_id).first
        available_credit_limit = get_available_credit_limit(buyer, current_company).to_f
        credit_limit = CreditLimit.where(buyer_id: transaction.buyer_id, seller_id: current_company.id).first
        used  =  get_used_credit_limit(buyer, current_company).to_f
        if credit_limit.nil?
          new_limit = parcel.total_value
        else
          new_limit = credit_limit.credit_limit + (parcel.total_value - available_credit_limit)
        end
        if available_credit_limit < parcel.total_value.to_f
          parcel.destroy
          render json: { sucess: false, message: "This buyer does not meet your credit requirements. It  will increase from  #{used} to #{new_limit}.  Do you want to continue ?" }
        else
          save_transaction(transaction, parcel)
        end
      end

      def check_overdue_and_market_limit(transaction, parcel)
        buyer = Company.where(id: transaction.buyer_id).first
        market_limit = CreditLimit.where(seller_id: current_company.id, buyer_id: buyer.id).first
        if (market_limit.present? && market_limit.market_limit.to_f < parcel.total_value.to_f) || current_company.has_overdue_transaction_of_30_days(transaction.buyer_id)
          # if market_limit < parcel.total_value.to_f || current_company.has_overdue_transaction_of_30_days(transaction.buyer_id)
          parcel.destroy
          render json: { sucess: false, message: "This Company does not meet your risk parameters. Do you wish to cancel the transaction?" }
        else
          check_credit_limit(transaction, parcel)
        end
      end
    end
  end
end
