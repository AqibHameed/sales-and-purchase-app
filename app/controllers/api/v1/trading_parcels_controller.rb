module Api
  module V1

    class TradingParcelsController <ApiController
      include LimitsHelper
      include SecureCenterHelper
      include LiveMonitor

      skip_before_action :verify_authenticity_token, only: [:create, :update, :direct_sell, :destroy, :request_limit_increase, :accept_limit_increase, :reject_limit_increase]

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
            parcel.send_mail_to_demanded
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

      # def index
      #   if current_customer
      #     parcels = current_company.trading_parcels.where(sold: false)
      #     render json: { success: true, parcels: list_parcel_data(parcels), response_code: 200 }
      #   else
      #     render json: { errors: "Not authenticated", response_code: 201 }
      #   end
      # end

      def available_trading_parcels
        if current_company
          @all_parcels = []
          @demand_suppliers = DemandSupplier.all
          DemandSupplier.all.each do |supplier|
            parcels = current_company.trading_parcels.where(sold: false).where("source LIKE ? ", supplier.name)
            parcel_h = []
            parcels.each do |parcel|
              parcels_with_d = current_company.trading_parcels.where(sold: false).where("source LIKE ? ", supplier.name).where("description LIKE ? ", parcel.description)
              parcel_h << {
                description: parcel.description,
                parcels: parcels_with_d.count
              }
            end
            demand_supplier = {
              id: supplier.id,
              name: supplier.name,
              parcels: parcel_h
            }
            @all_parcels << demand_supplier
          end
          respond_to do |format|
            format.json { render :available_trading_parcels }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def index
        if current_customer
          if params[:demand_supplier_id].present? 
            source = DemandSupplier.where(id: params[:demand_supplier_id]).first.name
          end
          parcel = current_company.trading_parcels.where(sold: false)
          parcel = current_company.trading_parcels.where(sold: false).where(source: source) if source.present?
          parcel = current_company.trading_parcels.where(sold: false).where(description: params[:description]) if params[:description].present?
          @parcels = parcel.page(params[:page]).per(params[:count])
          render json: { success: true, pagination: set_pagination(:parcels), parcels: list_parcel_data(@parcels), response_code: 200 }
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
              elsif params[:available_market_overdue].present? && params[:available_market_overdue] == true
                check_credit_limit(transaction, @parcel)
              else
                if registered_users < 1
                  if params[:trading_parcel][:my_transaction_attributes][:created_at].present? && (params[:trading_parcel][:my_transaction_attributes][:created_at].to_date < Date.current)
                    save_transaction(transaction, @parcel)
                  else
                    if buyer.buyer_transactions.count < 1
                      if params[:check_transactions].present? && params[:check_transactions] == true
                        check_credit_limit(transaction, @parcel)
                      elsif params[:check_transactions].present? && params[:check_transactions] == "false"
                      else
                        render json: { sucess: false, message: "No Information Available about this Company. Do you want to continue ?" }
                      end
                    else
                      check_credit_limit(transaction, @parcel)
                    end
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
        #buyer = Company.where(id: transaction.buyer_id).first
        #available_limit = get_available_credit_limit(transaction.buyer, current_company).to_f
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

          create_or_update_limits(transaction, parcel) if transaction.paid  == false

          parcel.update_attributes(sold: true)
          render json: { success: true, notice: 'Transaction added successfully'}
        else
          render json: { success: false, errors: transaction.errors.full_messages }
        end
      end

      def request_limit_increase
        parcel = TradingParcel.find(params[:id])
        render json: { errors: 'Parcel does not exist.' } and return unless parcel.present?
        render json: { errors: 'You are seller of this parcel.' } and return if current_company == parcel.company

        Message.request_limit_increase(parcel, current_company)
        render json: { success: true, message: "This request is sent successfully." }
      end

      def accept_limit_increase
        parcel = TradingParcel.find(params[:id])
        render json: { errors: 'Parcel does not exist.' } and return unless parcel.present?        
        render json: { errors: 'You are not seller of this parcel.' } and return unless current_company == parcel.company        
        buyer = Company.where(id: params[:buyer_id]).first
        render json: { errors: 'Buyer does not exist.' } and return unless buyer.present?
        days_limit = DaysLimit.where(buyer_id: buyer.id, seller_id: current_company.id).first.days_limit
        if !params[:accept].present? 
          render json: { message: "You are increasing limits for #{parcel.company.name}: Overdue Limit will now be 30 from #{days_limit}. Do you wish to continue?"}
        elsif params[:accept] == 'true'
          if buyer.has_overdue_transaction_of_30_days(current_company.id)          
            current_company.increase_overdue_limit(buyer.id, parcel)
          end
          render json: { success: true, message: "This request is accepted successfully." }
        else 
        end
      end

      def reject_limit_increase
        parcel = TradingParcel.find(params[:id])
        
        render json: { errors: 'Parcel does not exist.' } and return unless parcel.present?        
        render json: { errors: 'You are not seller of this parcel.' } and return unless current_company == parcel.company

        buyer = Company.where(id: params[:buyer_id]).first
        render json: { errors: 'Buyer does not exist.' } and return unless buyer.present?

        Message.reject_limit_increase(buyer.id, parcel)

        render json: { success: true, message: "This request is rejected." }
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
          cost: parcel.cost.to_f,
          discount_per_month: parcel.box_value,
          sight: parcel.sight,
          source: parcel.source,
          uid: parcel.uid,
          percent:  parcel.try(:percent).to_f,
          comment: parcel.comment.to_s,
          total_value: parcel.try(:total_value).to_f,
          no_of_demands: parcel.demand_count(parcel, current_company, false),
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
            #market_limit: get_market_limit_from_credit_limit_table(c, current_company).to_s,
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
          existing_limit = 0.to_f
          @credit_limit = parcel.total_value
        else
          existing_limit = credit_limit.credit_limit.to_f
          @credit_limit = credit_limit.credit_limit + (parcel.total_value - available_credit_limit)
        end
        if available_credit_limit < parcel.total_value.to_f
          parcel.destroy
          secure_center_record(current_company.id, transaction.buyer_id)
          #render json: { sucess: false, message: "You have set a credit limit of #{existing_limit}. This transaction will increase it to #{new_limit}. Do you wish to continue?" }
        else
          save_transaction(transaction, parcel)
        end
      end

    end
  end
end
