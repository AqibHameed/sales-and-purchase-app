module Api
  module V1
    class CustomersController < ApiController
      skip_before_action :verify_authenticity_token, only: [:update_profile, :update_password, :approve_reject_customer_request]
      before_action :current_customer
      before_action :current_company
      MOBILE_TILES_SHOW = {
          0 => 'Smart Search',
          1 => 'Sell',
          2 => 'Inbox',
          3 => 'History',
          4 => 'Live Monitor',
          5 => 'Public Channels',
          6 => 'Feedback',
          7 => 'Share App',
          8 => 'Invite',
          9 => 'Current Tenders',
          10 => 'Upcoming Tenders',
          11 => 'Protection',
          12 => 'Record Sale',
          13 => 'Past Tenders'
      }

      def profile
        if current_customer
          render json: { profile: profile_data(current_customer), response_code: 200 }
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def update_profile
        if current_customer
          if current_customer.update_attributes(customer_params)
            render json: { success: true, message: 'Profile Updated Successfully', response_code: 200 }
          else
            render json: { success: false, message: 'Invalid Parameters', response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def update_password
        render json: { errors: "Not authenticated", response_code: 201 } and return unless current_customer
        render json: { success: false, message: "Invalid Current Password", response_code: 201 } and return unless current_customer.valid_password?(password_params[:current_password])
        render json: { success: false, message: "Provide New Password", response_code: 201 } and return unless password_params[:password].present?
        render json: { success: false, message: "Provide New Password Confirmation", response_code: 201 } and return unless password_params[:password_confirmation].present?
        render json: { success: false, message: "Doesn't Match Password", response_code: 201 } and return unless password_params[:password] == password_params[:password_confirmation]
        if current_customer.update(password_params.except(:current_password))
          render json: { success: true, message: 'Password Updated Successfully', response_code: 200 }
        else
          render json: { success: true, message: 'Invalid Parameters', response_code: 200 }
        end
      end

      def get_user_requests
        if current_company
          @requested_customers = []
          @customers = current_company.customers.where.not(id: current_customer.id)
          @customers.each do |c|
            @requested_customers << {
              id: c.id,
              first_name: c.first_name,
              last_name: c.last_name,
              email: c.email,
              is_requested: c.is_requested
            }
          end
          render json: { success: true, requested_customers: @requested_customers, response_code: 201 }
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def approve_reject_customer_request
        customer = Customer.where(id: params[:id]).first
        if customer.present?
          if params[:perform] == 'accept'
            if customer.update_attributes(is_requested: false)
              CustomerMailer.approve_access(customer).deliver
              render json: { success: true, message: 'Access Granted', response_code: 200 }
            else
              render json: { success: false, message: 'Some thing went wrong.', response_code: 201 }
            end
          elsif params[:perform] == 'reject'
            if customer.update_attributes(is_requested: true)
              CustomerMailer.remove_access(customer).deliver
              render json: { success: true, message: 'Access Denied successfully!!', response_code: 200 }
            else
              render json: { success: false, message: 'Some thing went wrong.', response_code: 201 }
            end
          else
            render json: { success: false, message: 'Invalid Action', response_code: 201 }
          end
        else
          render json: { success: false, message: 'Invalid Customer ID', response_code: 201 }
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/access_tiles?tab=inbox
 @apiSampleRequest off
 @apiName access_tiles
 @apiGroup Customers
 @apiDescription permission the tiles and sorting the record on the basis of count
@apiParamExample {json} Request-Example:
{
	"tab": "smart_search",
  "tab": "sell",
  "tab": "inbox",
  "tab": "history",
  "tab": "live_monitor",
  "tab": "public_channels",
  "tab": "feedback",
  "tab": "share_app",
  "tab": "invite",
  "tab": "current_tenders",
  "tab": "upcoming_tenders",
  "tab": "protection",
  "tab": "record_sale",
  "tab": "past_tenders"
}
 @apiSuccessExample {json} SuccessResponse:
 {
  {
    "success": true,
    "messages": [
        {
            "Inbox": true,
            "count": 5
        },
        {
            "History": true,
            "count": 0
        },
        {
            "Smart Search": true,
            "count": 0
        }
    ]
  }
 }
=end


      def access_tiles

        if current_customer
            if current_customer.tiles_count.blank?
              current_customer.create_tiles_count
            end

            if params[:tab].present? && Customer::TILES.include?(params[:tab])
                  count = current_customer.tiles_count.send(params[:tab])
                  current_customer.tiles_count.update_attribute(params[:tab], count + 1)
            end
            if current_customer.has_role?("Buyer")
              @messages = [{MOBILE_TILES_SHOW[0] => true, count: current_customer.tiles_count.smart_search},
                           {MOBILE_TILES_SHOW[2] => true, count: current_customer.tiles_count.inbox},
                           {MOBILE_TILES_SHOW[3] => true, count: current_customer.tiles_count.history}]

              render json: { success: true, messages: @messages.sort_by { |hsh| hsh[:count] }.reverse! }

            elsif current_customer.has_role?("Trader")
              @messages = [{MOBILE_TILES_SHOW[0] => true, count: current_customer.tiles_count.smart_search},
                           {MOBILE_TILES_SHOW[1] => true, count: current_customer.tiles_count.sell},
                           {MOBILE_TILES_SHOW[2] => true, count: current_customer.tiles_count.inbox},
                           {MOBILE_TILES_SHOW[3] => true, count: current_customer.tiles_count.history},
                           {MOBILE_TILES_SHOW[4] => true, count: current_customer.tiles_count.live_monitor},
                           {MOBILE_TILES_SHOW[5] => true, count: current_customer.tiles_count.public_channels},
                           {MOBILE_TILES_SHOW[6] => true, count: current_customer.tiles_count.feedback},
                           {MOBILE_TILES_SHOW[7] => true, count: current_customer.tiles_count.share_app},
                           {MOBILE_TILES_SHOW[8] => true, count: current_customer.tiles_count.invite},
                           {MOBILE_TILES_SHOW[9] => true, count: current_customer.tiles_count.current_tenders},
                           {MOBILE_TILES_SHOW[10] => true, count: current_customer.tiles_count.upcoming_tenders},
                           {MOBILE_TILES_SHOW[11] => true, count: current_customer.tiles_count.protection},
                           {MOBILE_TILES_SHOW[12] => true, count: current_customer.tiles_count.record_sale},
                           {MOBILE_TILES_SHOW[13] => true, count: current_customer.tiles_count.past_tenders}]

              render json: { success: true, messages: @messages.sort_by { |hsh| hsh[:count] }.reverse! }

            elsif current_customer.has_role?("Broker")
              @messages =[{MOBILE_TILES_SHOW[5] => true, count: current_customer.tiles_count.public_channels},
                          {MOBILE_TILES_SHOW[6] => true, count: current_customer.tiles_count.feedback},
                          {MOBILE_TILES_SHOW[7] => true, count: current_customer.tiles_count.share_app},
                          {MOBILE_TILES_SHOW[8] => true, count: current_customer.tiles_count.invite},
                          {MOBILE_TILES_SHOW[9] => true, count: current_customer.tiles_count.current_tenders},
                          {MOBILE_TILES_SHOW[10] => true, count: current_customer.tiles_count.upcoming_tenders},
                          {MOBILE_TILES_SHOW[13] => true, count: current_customer.tiles_count.past_tenders}]

              render json: { success: true, messages: @messages.sort_by { |hsh| hsh[:count] }.reverse! }
            end

        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} api/v1/customers/transactions
 @apiSampleRequest off
 @apiName customer_transactions
 @apiGroup Customers
 @apiDescription permission the tiles and sorting the record on the basis of count
 @apiSuccessExample {json} SuccessResponse:
  {
    "success": true,
    "transactions": {
    "total": 11,
    "pending": 2,
    "completed": 8,
    "overdue": 1
  }
}
=end

      def transactions
        total = Transaction.where('(buyer_id = ? or seller_id = ?) and buyer_confirmed = ?', current_company.id, current_company.id, true).count
        pending = Transaction.where("(buyer_id = ? or seller_id = ?) AND due_date >= ? AND paid = ? AND buyer_confirmed = ?", current_company.id, current_company.id, Date.current, false, true).count
        overdue = Transaction.where("(buyer_id = ? or seller_id = ?) AND due_date < ? AND paid = ? AND buyer_confirmed = ?", current_company.id, current_company.id, Date.current, false, true).count
        completed = Transaction.where("(buyer_id = ? or seller_id = ?) AND paid = ? AND buyer_confirmed = ?", current_company.id, current_company.id, true, true).count
        render json: {success: true, transactions: {total: total, pending: pending,
                                                    completed: completed, overdue: overdue}}
      end

=begin
 @apiVersion 1.0.0
 @api {get} api/v1/customers/sales
 @apiSampleRequest off
 @apiName customer_sale
 @apiGroup Customers
 @apiDescription permission the tiles and sorting the record on the basis of count
 @apiSuccessExample {json} SuccessResponse:
    {
"success": true,
"credit_given_to": 5,
"total_given_credit": "129823.00",
"total_used_credit": "229022.89",
"total_available_credit": "-$99,199.89",
 "sales": {
    0: {
    "term": "cash",
    "percent": "0(0%)",
    "pending_transaction": "$0.00(0%)",
    "overdue_transaction": "$0.00(0%)",
    "complete_transaction": "$0.00(0%)"
    },
    1: {
    "term": "1<=30",
    "percent": "6(46%)",
    "pending_transaction": "$0.00(0%)",
    "overdue_transaction": "$40,000.00(100%)",
    "complete_transaction": "$269,400.00(85%)"
    },
    2: {
    "term": "61<=90",
    "percent": "3(23%)",
    "pending_transaction": "$46,200.00(100%)",
    "overdue_transaction": "$0.00(0%)",
    "complete_transaction": "$21,890.00(6%)"
    },
    3: {
    "term": "91",
    "percent": "0(0%)",
    "pending_transaction": "$0.00(0%)",
    "overdue_transaction": "$0.00(0%)",
    "complete_transaction": "$0.00(0%)"
    },
    4: {
    "term": "total",
    "percent": 13,
    "pending_transaction": "46200.0",
    "overdue_transaction": "40000.0",
    "complete_transaction": "315040.0"
    }
   }
  }
}
=end

      def sales
        @credit_given = CreditLimit.where('seller_id =?', current_company.id)
        credit_given_to = @credit_given.count
        total_credit_given = overall_credit_given(current_company)
        total_used_credit = overall_credit_spent_by_customer(current_company)
        total_available_credit = credit_available(current_company)
        @total_pending_sent = Transaction.pending_sent_transaction(current_company.id).sum(:total_amount)
        @total_overdue_sent = Transaction.overdue_sent_transaction(current_company.id).sum(:total_amount)
        @total_complete_sent = Transaction.complete_sent_transaction(current_company.id).sum(:total_amount)
        @credit_given_transaction = Transaction.where('seller_id =?', current_company.id)
        render json: {success: true, credit_given_to: credit_given_to, total_given_credit: total_credit_given,
                      total_used_credit: total_used_credit, total_available_credit: total_available_credit, sales: calculate_sales}

      end


=begin
 @apiVersion 1.0.0
 @api {get} api/v1/customers/purchases
 @apiSampleRequest off
 @apiName customer_purchases
 @apiGroup Customers
 @apiDescription to get customer purchasings info
 @apiSuccessExample {json} SuccessResponse:{
    {
        "success": true,
        "total_credit_recieved": 1,
        "total_credit_received": "$316.00",
    "purchases":{
        "0":{
        "term": "cash",
        "percent": "0(0%)",
        "Pending_Transaction": "$0.00(0%)",
        "Overdue_Transaction": "$0.00(0%)",
        "Complete_Transaction": "$0.00(0%)"
        },
        "1":{
        "term": "1<=30",
        "percent": "0(0%)",
        "Pending_Transaction": "$0.00(0%)",
        "Overdue_Transaction": "$0.00(0%)",
        "Complete_Transaction": "$0.00(0%)"
        },
        "2":{
        "term": "31<=60",
        "percent": "0(0%)",
        "Pending_Transaction": "$0.00(0%)",
        "Overdue_Transaction": "$0.00(0%)",
        "Complete_Transaction": "$0.00(0%)"
        },
        "3":{
        "term": "61<=90",
        "percent": "0(0%)",
        "Pending_Transaction": "$0.00(0%)",
        "Overdue_Transaction": "$0.00(0%)",
        "Complete_Transaction": "$0.00(0%)"
        },
        "4":{
        "term": "61<=90",
        "percent": "0(0%)",
        "Pending_Transaction": "$0.00(0%)",
        "Overdue_Transaction": "$0.00(0%)",
        "Complete_Transaction": "$0.00(0%)"
        },
        "5":{
        "term": "total",
        "percent": 0,
        "Pending_Transaction": "$0.00",
        "Overdue_Transaction": "$0.00",
        "Complete_Transaction": "$0.00"
        }
        },
        "response_code": 200
      }

}
=end
      def purchases
        @credit_recieved_transaction = Transaction.where('buyer_id =?', current_company.id)
        @total_pending_received = Transaction.pending_received_transaction(current_company.id).sum(:total_amount)
        @total_overdue_received = Transaction.overdue_received_transaction(current_company.id).sum(:total_amount)
        @total_complete_received = Transaction.complete_received_transaction(current_company.id).sum(:total_amount)
        @credit_recieved = CreditLimit.where('buyer_id =?', current_company.id)

        render json: {success: true, total_credit_recieved: @credit_recieved.count, total_credit_received: number_to_currency(overall_credit_received(current_company)), purchases: cutomer_puchase, response_code: 200}

      end

=begin
 @apiVersion 1.0.0
 @api {get} api/v1/customers/feedback_rating
 @apiSampleRequest off
 @apiName feedback_rating
 @apiGroup Customers
 @apiDescription to get customer feedback info, You can send
  "proposal_id": "1" or
  "demand_id": "1" or
  "partial_payment_id": "1" or
  "credit_limit_id": "1" or
  trading_parcel_id": "1",

@apiParamExample {json} Request-Example:

{
	"trading_parcel_id": "1",
  "star": "4"
    "comment": "This seller is Good"


}
 @apiSuccessExample {json} SuccessResponse:{
 {
  "feedback": {
          "id": 1,
          "comments": null,
          "feedback_rating": 3,
          "trading_parcel_id": 1
      },
   "response_code": 200
}
=end
      def feedback_rating
        if current_customer
          if params[:trading_parcel_id].present?
            params_attribute = 'trading_parcel_id'
            feedback_on_model = TradingParcel.find_by(id: params[:trading_parcel_id])
          elsif  params[:proposal_id].present?
            params_attribute = 'proposal_id'
            feedback_on_model = Proposal.find_by(id: params[:proposal_id])
          elsif  params[:demand_id].present?
            params_attribute = 'demand_id'
            feedback_on_model = Demand.find_by(id: params[:demand_id])
          elsif  params[:partial_payment_id].present?
            params_attribute = 'partial_payment_id'
            feedback_on_model = PartialPayment.find_by(id: params[:partial_payment_id])
          elsif  params[:credit_limit_id].present?
            params_attribute = 'credit_limit_id'
            feedback_on_model = CreditLimit.find_by(id:params[:credit_limit_id])
          end
          if feedback_on_model.nil?
            errors = ['Record not found']
            render :json => {:errors => errors, response_code: 201}
          else
            feedback_rating = Feedback.find_by(params_attribute => feedback_on_model.id, customer_id: current_customer.id)
            if feedback_rating.nil?
              feedback_rating = Feedback.new(comment: params[:comments], star: params[:rating], params_attribute => feedback_on_model.id, customer_id: current_customer.id)
            else
              feedback_rating.comment = params[:comment] unless params[:comment].blank?
              feedback_rating.star = params[:rating] unless params[:rating].blank?
            end
            if feedback_rating.save
              render :json => {feedback: feedback(feedback_rating, params_attribute, feedback_on_model.id), response_code: 200}
            else
              render :json => {:errors => feedback_rating.errors.full_messages, response_code: 201}
            end
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}, status: :unauthorized
        end
      end

      private

      def customer_params
        params.require(:customer).permit(:first_name, :last_name, :email, :mobile_no, :phone_2, :phone, :address, :city, :company, :company_address, :certificate)
      end

      def password_params
        params.require(:customer).permit(:current_password, :password, :password_confirmation)
      end

      def profile_data(customer)
        {
          id: customer.id,
          first_name: customer.first_name,
          last_name: customer.last_name,
          email: customer.email,
          phone: customer.phone,
          city: customer.city,
          address: customer.address,
          phone_2: customer.phone_2,
          mobile_no: customer.mobile_no,
          company: customer.company.name,
          company_address: customer.company_address,
          created_at: customer.created_at,
          updated_at: customer.updated_at
        }
      end

      def feedback(feedback_rating, params_attribute, model_id)
        {
            id: feedback_rating.id,
            comments: feedback_rating.comment,
            feedback_rating: feedback_rating.star,
            params_attribute => model_id
        }
      end
    end
  end
end
