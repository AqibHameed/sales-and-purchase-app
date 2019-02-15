module Api
  module V1

    class TradingParcelsController < ApiController
      include LimitsHelper
      include SecureCenterHelper
      include LiveMonitor
      include ApplicationHelper

      skip_before_action :verify_authenticity_token, only: [:create, :update, :direct_sell, :destroy, :request_limit_increase, :accept_limit_increase, :reject_limit_increase, :available_trading_parcels]

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/trading_parcels
 @apiSampleRequest off
 @apiName create
 @apiGroup TradingParcels
 @apiDescription create parcel
 @apiParamExample {json} Request-Example:
{"trading_parcel":
   {
   	   "source": "SPECIAL",
	   "description": "5-10 Cts BLK CLIV WHITE",
	   "credit_period": "2000",
	   "no_of_stones": "10",
	   "total_value": 5000.0,
	   "percent": "10",
	   "cost": 4500.0,
	   "avg_price": 5000.0,
	   "carats": 1,
	   "comment": "",
	   "discout": "",
	   "sight": "",
	   "lot_no":"",
	   "parcel_size_infos_attributes":[
	   	  {
	   	    "size": "M",
	   	    "percent": 20,
	   	    "_destroy": "false"
	   	  },
	   	  {
	   	    "size": "1",
	   	    "percent": 30,
	   	    "_destroy": "false"
	   	  }
	   ]
   }
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": "Parcel created successfully"
}
=end

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
            render json: {success: true, message: 'Parcel created successfully'}
          else
            render json: {success: false, errors: parcel.errors.full_messages, response_code: 200}
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
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
            render json: {success: true, message: 'Parcel updated successfully', response_code: 200}
          else
            render json: {success: false, errors: parcel.errors.full_messages}
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/trading_parcels/3
 @apiSampleRequest off
 @apiName show
 @apiGroup TradingParcels
 @apiDescription show trading parcel with parcel_id = 3
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "parcel": {
        "id": "57",
        "description": "+9 SAWABLES LIGHT",
        "lot_no": null,
        "no_of_stones": 1,
        "carats": 1,
        "credit_period": 15,
        "avg_price": 1.01,
        "company": "Seller B",
        "cost": 1,
        "discount_per_month": null,
        "sight": "12/2018",
        "source": "RUSSIAN",
        "uid": "8cb06e17",
        "percent": 1,
        "comment": "",
        "total_value": 1.01,
        "no_of_demands": 4,
        "size_info": [],
        "vital_sales_data": {
            "demanded_clients": [
                {
                    "id": 1,
                    "name": "Buyer A",
                    "city": null,
                    "country": "India",
                    "created_at": "2018-12-02T08:04:34.000Z",
                    "updated_at": "2018-12-26T13:54:45.000Z",
                    "is_anonymous": false,
                    "add_polished": false,
                    "is_broker": true,
                    "users": [
                        {
                            "user_id": 22,
                            "first_name": "aqib",
                            "last_name": null
                        },
                        {
                            "user_id": 11,
                            "first_name": "az",
                            "last_name": "za"
                        },
                        {
                            "user_id": 29,
                            "first_name": "rizwan",
                            "last_name": "ali"
                        },
                        {
                            "user_id": 30,
                            "first_name": "rizwan",
                            "last_name": "ali"
                        },
                        {
                            "user_id": 10,
                            "first_name": "Buyer",
                            "last_name": "B"
                        },
                        {
                            "user_id": 4,
                            "first_name": "he",
                            "last_name": "she"
                        },
                        {
                            "user_id": 14,
                            "first_name": "Dummy",
                            "last_name": "Buyer 1"
                        },
                        {
                            "user_id": 19,
                            "first_name": "niraj",
                            "last_name": "patel"
                        },
                        {
                            "user_id": 20,
                            "first_name": "niraj s",
                            "last_name": "patel"
                        }
                    ],
                    "rank": null
                },
                {
                    "id": 2,
                    "name": "Buyer B",
                    "city": null,
                    "country": "India",
                    "created_at": "2018-12-02T08:04:34.000Z",
                    "updated_at": "2018-12-02T08:04:34.000Z",
                    "is_anonymous": false,
                    "add_polished": false,
                    "is_broker": false,
                    "users": [
                        {
                            "user_id": 22,
                            "first_name": "aqib",
                            "last_name": null
                        },
                        {
                            "user_id": 11,
                            "first_name": "az",
                            "last_name": "za"
                        },
                        {
                            "user_id": 29,
                            "first_name": "rizwan",
                            "last_name": "ali"
                        },
                        {
                            "user_id": 30,
                            "first_name": "rizwan",
                            "last_name": "ali"
                        },
                        {
                            "user_id": 10,
                            "first_name": "Buyer",
                            "last_name": "B"
                        },
                        {
                            "user_id": 4,
                            "first_name": "he",
                            "last_name": "she"
                        },
                        {
                            "user_id": 14,
                            "first_name": "Dummy",
                            "last_name": "Buyer 1"
                        },
                        {
                            "user_id": 19,
                            "first_name": "niraj",
                            "last_name": "patel"
                        },
                        {
                            "user_id": 20,
                            "first_name": "niraj s",
                            "last_name": "patel"
                        }
                    ],
                    "rank": 10
                },
                {
                    "id": 3,
                    "name": "Buyer C",
                    "city": null,
                    "country": "India",
                    "created_at": "2018-12-02T08:04:34.000Z",
                    "updated_at": "2018-12-02T08:04:34.000Z",
                    "is_anonymous": false,
                    "add_polished": false,
                    "is_broker": false,
                    "users": [
                        {
                            "user_id": 22,
                            "first_name": "aqib",
                            "last_name": null
                        },
                        {
                            "user_id": 11,
                            "first_name": "az",
                            "last_name": "za"
                        },
                        {
                            "user_id": 29,
                            "first_name": "rizwan",
                            "last_name": "ali"
                        },
                        {
                            "user_id": 30,
                            "first_name": "rizwan",
                            "last_name": "ali"
                        },
                        {
                            "user_id": 10,
                            "first_name": "Buyer",
                            "last_name": "B"
                        },
                        {
                            "user_id": 4,
                            "first_name": "he",
                            "last_name": "she"
                        },
                        {
                            "user_id": 14,
                            "first_name": "Dummy",
                            "last_name": "Buyer 1"
                        },
                        {
                            "user_id": 19,
                            "first_name": "niraj",
                            "last_name": "patel"
                        },
                        {
                            "user_id": 20,
                            "first_name": "niraj s",
                            "last_name": "patel"
                        }
                    ],
                    "rank": null
                },
                {
                    "id": 7,
                    "name": "Dummy Buyer 1",
                    "city": "",
                    "country": "India",
                    "created_at": "2018-12-06T09:12:48.000Z",
                    "updated_at": "2018-12-06T09:12:48.000Z",
                    "is_anonymous": false,
                    "add_polished": false,
                    "is_broker": false,
                    "users": [
                        {
                            "user_id": 22,
                            "first_name": "aqib",
                            "last_name": null
                        },
                        {
                            "user_id": 11,
                            "first_name": "az",
                            "last_name": "za"
                        },
                        {
                            "user_id": 29,
                            "first_name": "rizwan",
                            "last_name": "ali"
                        },
                        {
                            "user_id": 30,
                            "first_name": "rizwan",
                            "last_name": "ali"
                        },
                        {
                            "user_id": 10,
                            "first_name": "Buyer",
                            "last_name": "B"
                        },
                        {
                            "user_id": 4,
                            "first_name": "he",
                            "last_name": "she"
                        },
                        {
                            "user_id": 14,
                            "first_name": "Dummy",
                            "last_name": "Buyer 1"
                        },
                        {
                            "user_id": 19,
                            "first_name": "niraj",
                            "last_name": "patel"
                        },
                        {
                            "user_id": 20,
                            "first_name": "niraj s",
                            "last_name": "patel"
                        }
                    ],
                    "rank": 40
                }
            ]
        }
    },
    "response_code": 200
  }
=end

      def show
        if current_customer
          parcel = TradingParcel.where(id: params[:id]).first
          if parcel.nil?
            render json: {sucess: false, message: 'Parcel not found'}
          else
            render json: {success: true, parcel: parcel_data(parcel), response_code: 200}
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
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
          render status: :ok, template: "api/v1/trading_parcels/available_trading_parcels.json.jbuilder"
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end


=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/trading_parcels
 @apiSampleRequest off
 @apiName index
 @apiGroup TradingParcels
 @apiDescription show list of trading parcel
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "pagination": {
        "total_pages": 1,
        "prev_page": null,
        "next_page": null,
        "current_page": 1
    },
    "parcels": [
        {
            "id": "10744",
            "source": "OUTSIDE",
            "description": "Dummy Parcel for Demo",
            "total_value": "100.00"
        },
        {
            "id": "10746",
            "source": "POLISHED",
            "description": null,
            "total_value": "240.00"
        }
    ],
    "response_code": 200
}
=end

      def index
        if current_customer
          if params[:demand_supplier_id].present?
            source = DemandSupplier.where(id: params[:demand_supplier_id]).first.name
          end
          parcel = current_company.trading_parcels.where(sold: false)
          parcel = current_company.trading_parcels.where(sold: false).where(source: source) if source.present?
          parcel = current_company.trading_parcels.where(sold: false).where(description: params[:description]) if params[:description].present?
          @parcels = parcel.page(params[:page]).per(params[:count])
          render json: {success: true, pagination: set_pagination(:parcels), parcels: list_parcel_data(@parcels), response_code: 200}
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end

=begin
 @apiVersion 1.0.0
 @api {delete} /api/v1/trading_parcels/1
 @apiSampleRequest off
 @apiName destroy
 @apiGroup TradingParcels
 @apiDescription delete customer's parcels parcel_id = 1
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": "This parcel is deleted successfully."
}
=end

      def destroy
        if current_company
          @parcel = current_company.trading_parcels.find_by(id: params[:id])
          if @parcel.present?
            if @parcel.destroy
              render json: {success: true, message: "Your parcel is deleted successfully."}
            else
              render json: {errors: @parcel.errors.full_messages}
            end
          else
            render json: {errors: 'Parcel does not exist.'}
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/trading_parcels/direct_sell
 @apiSampleRequest off
 @apiName direct sell
 @apiGroup TradingParcels
 @apiDescription direct sell (3,4 request where role is trader and have to send activity param with buy or sell) and direct buyer (2 request where role is buyer)
 @apiParamExample {json} Request-Example1:
{
            "trading_parcel": {
                "description": "Z -7+5T",
                "activity": "sell",
                "my_transaction_attributes": {
                    "company_id": "11",
                    "paid": false
                },
                "no_of_stones": 10,
                "carats": 1,
                "credit_period": 20,
                "price": 2200,
                "company": "SafeTrade",
                "cost": 2000,
                "sight": "12/2018",
                "source": "DTC",
                "percent": 10,
                "comment": "",
                "total_value": 2200
            },
            "check_transactions": true
}
 @apiSuccessExample {json} SuccessResponse1:
{
    "success": false,
    "details": {
        "id": 257,
        "invoices_overdue": 0,
        "paid_date": null,
        "buyer_id": 11,
        "seller_id": 4,
        "last_bought_on": null,
        "supplier_connected": 0,
        "credit_limit": true,
        "overdue_limit": false,
        "overdue_amount": 0,
        "outstandings": 0,
        "buyer_percentage": 0,
        "system_percentage": 31.46
    }
}
@apiParamExample {json} Request-Example2:
 {
  "trading_parcel":
                  {
                  "description":"+11 SAWABLES LIGHT",
                  "my_transaction_attributes":
                                             {
                                               "customer_id":"2",
                                               "paid":false,
                                               "created_at":"23/11/2018"
                                             },
                   "no_of_stones":10,
                   "carats":1.0,
                   "credit_period":20,
                   "price":6600.0,
                   "company":"SafeTrade",
                   "cost":6000.0,
                   "sight":"11/2018",
                   "source":"RUSSIAN",
                   "percent":10.0,
                   "comment":"",
                   "total_value":7000.0

                  },
                  "available_credit_limit": true

}
@apiSuccessExample {json} SuccessResponse2:
 [
  {
    "success": true,
    "notice": "Transaction added successfully"
  }
 ]
@apiParamExample {json} Request-Example3:
{
  "trading_parcel":
                  {
                  "description":"+11 SAWABLES LIGHT",
                  "activity": "buy",
                  "my_transaction_attributes":
                                             {
                                               "company_id":"2",
                                               "paid":false,
                                               "created_at":"23/11/2018"
                                             },
                   "no_of_stones":10,
                   "carats":1.0,
                   "credit_period":20,
                   "price":6600.0,
                   "company":"SafeTrade",
                   "cost":6000.0,
                   "sight":"11/2018",
                   "source":"RUSSIAN",
                   "percent":10.0,
                   "comment":"",
                   "total_value":7000.0

                  },
                  "available_credit_limit": true

}
@apiSuccessExample {json} SuccessResponse3:
 [
  {
    "success": true,
    "notice": "Transaction added successfully"
  }
 ]
@apiParamExample {json} Request-Example4:
{
  "trading_parcel":
                  {
                  "description":"+11 SAWABLES LIGHT",
                  "activity": "sell",
                  "my_transaction_attributes":
                                             {
                                               "company_id":"2",
                                               "paid":false,
                                               "created_at":"23/11/2018"
                                             },
                   "no_of_stones":10,
                   "carats":1.0,
                   "credit_period":20,
                   "price":6600.0,
                   "company":"SafeTrade",
                   "cost":6000.0,
                   "sight":"11/2018",
                   "source":"RUSSIAN",
                   "percent":10.0,
                   "comment":"",
                   "total_value":7000.0

                  },
                  "available_credit_limit": true

}
@apiSuccessExample {json} SuccessResponse4:
 [
  {
    "success": true,
    "notice": "Transaction added successfully"
  }
 ]
=end


      def direct_sell
        if current_customer
          @parcel = TradingParcel.new(trading_parcel_params)
          company_id = params[:trading_parcel][:my_transaction_attributes]['company_id']
          company = Company.find_by(id: company_id)
          if company.nil?
            render json: {success: false, message: "Customer does not present"}
          else
            @parcel.weight = params[:trading_parcel][:carats]
            @parcel.box_value = params[:trading_parcel][:discount]
            @parcel.sold = true
            if current_customer.has_role?(Role::BUYER)
              @parcel.company_id = company_id
              if @parcel.save
                transaction = Transaction.new(buyer_id: current_company.id, seller_id: @parcel.try(:company_id), trading_parcel_id: @parcel.id, paid: params[:trading_parcel][:my_transaction_attributes][:paid],
                                              price: @parcel.try(:price), credit: @parcel.try(:credit_period), diamond_type: @parcel.try(:diamond_type), transaction_type: 'manual',
                                              created_at: params[:trading_parcel][:my_transaction_attributes][:created_at])
                buyer = @parcel.company
                registered_users = buyer.customers.count
              else
                render json: {success: false, errors: @parcel.errors.full_messages}
              end
            elsif current_customer.has_role?(Role::TRADER)
              if params[:trading_parcel][:activity] == 'sell'
                @parcel.company_id = current_company.id
                @parcel.customer_id = current_customer.id
                if @parcel.save
                  transaction = Transaction.new(buyer_id: company_id, seller_id: @parcel.try(:company_id), trading_parcel_id: @parcel.id, paid: params[:trading_parcel][:my_transaction_attributes][:paid],
                                                price: @parcel.try(:price), credit: @parcel.try(:credit_period), diamond_type: @parcel.try(:diamond_type), transaction_type: 'manual',
                                                created_at: params[:trading_parcel][:my_transaction_attributes][:created_at])
                  buyer = @parcel.company
                  registered_users = buyer.customers.count
                else
                  render json: {success: false, errors: @parcel.errors.full_messages}
                end
              elsif params[:trading_parcel][:activity] == 'buy'
                @parcel.company_id = company_id
                if @parcel.save
                  transaction = Transaction.new(buyer_id: current_company.id, seller_id: @parcel.try(:company_id), trading_parcel_id: @parcel.id, paid: params[:trading_parcel][:my_transaction_attributes][:paid],
                                                price: @parcel.try(:price), credit: @parcel.try(:credit_period), diamond_type: @parcel.try(:diamond_type), transaction_type: 'manual',
                                                created_at: params[:trading_parcel][:my_transaction_attributes][:created_at])
                  buyer = @parcel.company
                  registered_users = buyer.customers.count
                else
                  render json: {success: false, errors: @parcel.errors.full_messages}
                end
              end
            end
            unless transaction.nil?
              if transaction.paid == true
                save_transaction(transaction, @parcel)
              elsif (params[:over_credit_limit].present? && params[:over_credit_limit] == true) || (params[:overdue_days_limit].present? && params[:overdue_days_limit] == true)
                save_transaction(transaction, @parcel)
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
                        render json: {sucess: false, message: "No Information Available about this Company. Do you want to continue ?"}
                      end
                    else
                      check_credit_limit(transaction, @parcel)
                    end
                  end
                else
                  save_transaction(transaction, @parcel)
                end
              end
            end
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end

      def save_transaction(transaction, parcel)
        #buyer = Company.where(id: transaction.buyer_id).first
        #available_limit = get_available_credit_limit(transaction.buyer, current_company).to_f
        if transaction.save

          SendNotificationJob.perform_now(transaction, current_company)
          create_or_update_limits(transaction, parcel) if transaction.paid == false
          parcel.update_attributes(sold: true)
          render json: {success: true, notice: 'Transaction added successfully'}
        else
          render json: {success: false, errors: transaction.errors.full_messages}
        end
      end

      def request_limit_increase
        parcel = TradingParcel.find(params[:id])
        render json: {errors: 'Parcel does not exist.'} and return unless parcel.present?
        render json: {errors: 'You are seller of this parcel.'} and return if current_company == parcel.company

        Message.request_limit_increase(parcel, current_company)
        render json: {success: true, message: "This request is sent successfully."}
      end

      def accept_limit_increase
        parcel = TradingParcel.find(params[:id])
        render json: {errors: 'Parcel does not exist.'} and return unless parcel.present?
        render json: {errors: 'You are not seller of this parcel.'} and return unless current_company == parcel.company
        buyer = Company.where(id: params[:buyer_id]).first
        render json: {errors: 'Buyer does not exist.'} and return unless buyer.present?
        days_limit = DaysLimit.where(buyer_id: buyer.id, seller_id: current_company.id).first.days_limit
        if !params[:accept].present?
          render json: {message: "You are increasing limits for #{parcel.company.name}: Overdue Limit will now be 30 from #{days_limit}. Do you wish to continue?"}
        elsif params[:accept] == 'true'
          if buyer.has_overdue_transaction_of_30_days(current_company.id)
            current_company.increase_overdue_limit(buyer.id, parcel)
          end
          render json: {success: true, message: "This request is accepted successfully."}
        else
        end
      end

      def reject_limit_increase
        parcel = TradingParcel.find(params[:id])

        render json: {errors: 'Parcel does not exist.'} and return unless parcel.present?
        render json: {errors: 'You are not seller of this parcel.'} and return unless current_company == parcel.company

        buyer = Company.where(id: params[:buyer_id]).first
        render json: {errors: 'Buyer does not exist.'} and return unless buyer.present?

        Message.reject_limit_increase(buyer.id, parcel)

        render json: {success: true, message: "This request is rejected."}
      end


      private

      def parcel_params
        params.require(:trading_parcel).permit(:company_id, :customer_id, :credit_period, :lot_no, :diamond_type, :description, :no_of_stones, :weight, :source, :box, :cost, :box_value, :sight, :percent, :comment, :total_value,
                                               parcel_size_infos_attributes: [:id, :carats, :percent, :size, :_destroy])
      end

      def trading_parcel_params
        params.require(:trading_parcel).permit(:description, :source, :sight, :cost, :no_of_stones, :percent, :credit_period, :price, :total_value)
      end

      def parcel_data(parcel)
        companies_total_scores = []
        # available_customers = get_available_buyers(parcel, current_customer)
        # not_enough_available_customers = get_unavailable_buyers(parcel, current_customer)
        # demanded_but_not_available = get_demanded_but_not_available_buyers(parcel, current_customer)
        demanded_clients = []
        users = []
        all_demanded_clients = get_demanded_clients(parcel, current_company)
        all_demanded_clients.each do |company|
          companies_total_scores << company.get_buyer_score
        end
        update_buyer_rank(companies_total_scores)
        all_demanded_clients.each do |client|
          client.customers.each do |customer|
            details = {
                user_id: customer.id,
                first_name: customer.first_name,
                last_name: customer.last_name
            }
            users << details
          end
          buyer_score = BuyerScore.find_by(company_id: client.id)
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
              users: users,
              rank: buyer_score.rank
          }
          demanded_clients << @data
        end
        @info = []
        parcel.parcel_size_infos.each do |i|
          size = i.size
          per = i.percent.to_f
          @info << {size: size, percent: per}
        end
        respose_hash = {
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
            percent: parcel.try(:percent).to_f,
            comment: parcel.comment.to_s,
            total_value: parcel.try(:total_value).to_f,
            no_of_demands: parcel.demand_count(parcel, current_company, false),
            size_info: @info,
            vital_sales_data: {
                demanded_clients: demanded_clients
            }
        }
      end

      def update_buyer_rank(companies_total_scores)
        final_score = companies_total_scores.map{|company_score| company_score if company_score.total != 0.0}.compact.sort_by(&:total)

        total_companies = companies_total_scores.count
        ten_percent = ((total_companies / 100.to_f) * 10)
        twenty_percent = ((total_companies / 100.to_f) * 20)
        fourty_percent = ((total_companies / 100.to_f) * 40)
        hundred_percent = ((total_companies / 100.to_f) * 100)

        percentile_rank(final_score, ten_percent, twenty_percent, fourty_percent, hundred_percent)

      end

      def percentile_rank(final_score, ten_percent, twenty_percent, fourty_percent, hundred_percent)
        rank = ''
        final_score.each do |percentage|
          if final_score.index(percentage) <= ten_percent
            rank = 10
          elsif final_score.index(percentage) > ten_percent && final_score.index(percentage) <= twenty_percent
            rank = 20
          elsif final_score.index(percentage) > twenty_percent && final_score.index(percentage) <= fourty_percent
            rank = 40
          elsif final_score.index(percentage) > fourty_percent && final_score.index(percentage) <= hundred_percent
            rank = nil
          end
          buyer_score = BuyerScore.find_by(company_id: percentage[:company_id])
          if buyer_score.present?
            buyer_score.update(rank: rank)
          end
        end
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
          @data << {id: parcel.id.to_s, source: parcel.source, description: parcel.description, total_value: total_value}
        end
        @data
      end

      def check_credit_limit(transaction, parcel)
        alert = []
        buyer = transaction.buyer
        available_credit_limit = get_available_credit_limit(buyer, current_company).to_f
        @company_group = CompaniesGroup.where("company_id like '%#{transaction.buyer_id}%'").find_by(seller_id: current_company.id)
        if available_credit_limit < parcel.total_value.to_f
          @credit_limit = true
          alert << @credit_limit
        else
          @credit_limit = false
        end

        if @company_group.blank?
          if current_company.has_overdue_seller_setlimit(transaction.buyer_id)
            @days_limit = true
            alert << @days_limit
          else
            @days_limit = false
          end
        else
          if check_for_group_overdue_limit(current_company, transaction.buyer)
            @days_limit = true
            alert << @days_limit
          else
            @days_limit = false
          end
        end
        if alert.blank?
          save_transaction(transaction, parcel)
          #render json: { sucess: false, message: "You have set a credit limit of #{existing_limit}. This transaction will increase it to #{new_limit}. Do you wish to continue?" }
        else
          parcel.destroy
          secure_center_record(current_company, transaction.buyer_id)
        end

      end

    end
  end
end
