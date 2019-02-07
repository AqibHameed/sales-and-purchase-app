module Api
  module V1
    class CustomersController < ApiController
      skip_before_action :verify_authenticity_token, only: [:update_profile, :update_password, :approve_reject_customer_request, :buyer_scores, :seller_scores]
      before_action :current_customer
      before_action :info_permission, only: [:info]
      before_action :buyer_score_permission, only: [:buyer_scores]
      before_action :seller_scores_permission, only: [:seller_scores]
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

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/customers/buyer_scores
 @apiName buyer scores
 @apiGroup Customers
 @apiDescription get Buyer scores
 @apiParamExample {json} Request-Example1:
  {
    receiver_id: ""
  }
  @apiSuccessExample {json} SuccessResponse1:
  {
    "errors": "company id not exist",
    "response_code": 201
  }
  @apiParamExample {json} Request-Example2:
  {
    receiver_id: "1"
  }
  @apiSuccessExample {json} SuccessResponse2:
   {
      "errors": "permission Access denied",
      "response_code": 201
   }
  @apiParamExample {json} Request-Example3:
  {
    receiver_id: "2"
  }
 @apiSuccessExample {json} SuccessResponse3:
 {
    "success": true,
    "buyer_score": 0.39,
    "scores": [
        {
            "name": "Late Payment",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": null
        },
        {
            "name": "Current Risk Score",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": null
        },
        {
            "name": "Network Diversity",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": null
        },
        {
            "name": "Buyer Network Score",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": null
        },
        {
            "name": "Due Date Score",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": null
        },
        {
            "name": "Credit Used Score",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": null
        },
        {
            "name": "Number Of Suppliers Giving You Credit",
            "user_score": 1,
            "market_average": 2.57,
            "user_score_vs_market_score": 0.39,
            "rank": 10
        }
    ],
    "response_code": 200
  }
=end

      def buyer_scores
        @data = []
        if current_company
          buyer_score = current_company.get_buyer_score
          market_buyer_score = MarketBuyerScore.get_scores
          if current_customer.has_role?(Role::BROKER) || current_customer.has_role?(Role::TRADER)
            scores = nil
          elsif current_customer.has_role?(Role::BUYER)
            scores = get_scores(buyer_score, market_buyer_score)
          end
          render json: {success: true,
                        buyer_score: buyer_score.total,
                        scores: scores,
                        response_code: 200}
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/customers/seller_scores
 @apiName seller scores
 @apiGroup Customers
 @apiDescription get seller scores
 @apiParamExample {json} Request-Example1:
  {
    receiver_id: ""
  }
  @apiSuccessExample {json} SuccessResponse1:
  {
    "errors": "company id not exist",
    "response_code": 201
  }
  @apiParamExample {json} Request-Example2:
  {
    receiver_id: "1"
  }
  @apiSuccessExample {json} SuccessResponse2:
   {
      "errors": "permission Access denied",
      "response_code": 201
   }
  @apiParamExample {json} Request-Example3:
  {
    receiver_id: "2"
  }
 @apiSuccessExample {json} SuccessResponse3:
 {
    "success": true,
    "seller_score": 0,
    "scores": [
        {
            "name": "Late Payment",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": null
        },
        {
            "name": "Current Risk Score",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": null
        },
        {
            "name": "Network Diversity",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": null
        },
        {
            "name": "Seller Network Score",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": null
        },
        {
            "name": "Due Date Score",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": null
        },
        {
            "name": "Credit Used Score",
            "user_score": 0,
            "market_average": 0,
            "user_score_vs_market_score": 0,
            "rank": 10
        }
    ],
    "response_code": 200
  }
=end

      def seller_scores
        @data = []
        if current_company
          seller_score = current_company.get_seller_score
          market_seller_score = MarketSellerScore.get_scores
          if current_customer.has_role?(Role::BROKER) || current_customer.has_role?(Role::TRADER)
            scores = nil
          elsif current_customer.has_role?(Role::BUYER)
            scores = get_seller_scores(seller_score, market_seller_score)
          end
          render json: {success: true, seller_score: seller_score.total,
                        scores: scores,
                        response_code: 200}
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
  @api {get} /api/v1/customers/info
  @apiSampleRequest off
  @apiName info
  @apiGroup Customers
  @apiDescription to get customer purchasings, transaction and sales info
  @apiParamExample {json} Request-Example1:
  {
    receiver_id: ""
  }
  @apiSuccessExample {json} SuccessResponse1:
  {
    "errors": "company id not exist",
    "response_code": 201
  }
  @apiParamExample {json} Request-Example2:
  {
    receiver_id: "1"
  }
  @apiSuccessExample {json} SuccessResponse2:
   {
      "errors": "permission Access denied",
      "response_code": 201
   }
  @apiParamExample {json} Request-Example3:
  {
    receiver_id: "2"
  }
  @apiSuccessExample {json} SuccessResponse3:
  {
    "success": true,
    "sales": {
        "credit_given_to": 3,
        "total_given_credit": "22695.00",
        "total_used_credit": "16154.33",
        "total_available_credit": "$6,540.67",
        "sales": [
            {
                "term": "cash",
                "percent": "0(0%)",
                "pending_transaction": "$0.00(0%)",
                "overdue_transaction": "$0.00(0%)",
                "complete_transaction": "$0.00(0%)"
            },
            {
                "term": "1<=30",
                "percent": "11(68%)",
                "pending_transaction": "$0.00(0%)",
                "overdue_transaction": "$13,200.00(89%)",
                "complete_transaction": "$18,849.26(75%)"
            },
            {
                "term": "61<=90",
                "percent": "1(6%)",
                "pending_transaction": "$0.00(0%)",
                "overdue_transaction": "$0.00(0%)",
                "complete_transaction": "$4,500.00(18%)"
            },
            {
                "term": "91",
                "percent": "2(12%)",
                "pending_transaction": "$26.25(100%)",
                "overdue_transaction": "$0.00(0%)",
                "complete_transaction": "$1,549.04(6%)"
            },
            {
                "term": "total",
                "percent": "16",
                "pending_transaction": "$26.25",
                "overdue_transaction": "$14,749.04",
                "complete_transaction": "$24,898.30"
            }
        ]
    },
    "purchases": {
        "credit_recieved_count": 1,
        "total_credit_received": "$3,300.00",
        "purchases": [
            {
                "term": "cash",
                "percent": "0(0%)",
                "pending_transaction": "$0.00(0%)",
                "overdue_transaction": "$0.00(0%)",
                "complete_transaction": "$0.00(0%)"
            },
            {
                "term": "1<=30",
                "percent": "1(100%)",
                "pending_transaction": "$0.00(0%)",
                "overdue_transaction": "$0.00(0%)",
                "complete_transaction": "$3,300.00(100%)"
            },
            {
                "term": "31<=60",
                "percent": "0(0%)",
                "pending_transaction": "$0.00(0%)",
                "overdue_transaction": "$0.00(0%)",
                "complete_transaction": "$0.00(0%)"
            },
            {
                "term": "61<=90",
                "percent": "0(0%)",
                "pending_transaction": "$0.00(0%)",
                "overdue_transaction": "$0.00(0%)",
                "complete_transaction": "$0.00(0%)"
            },
            {
                "term": "61<=90",
                "percent": "0(0%)",
                "pending_transaction": "$0.00(0%)",
                "overdue_transaction": "$0.00(0%)",
                "complete_transaction": "$0.00(0%)"
            },
            {
                "term": "total",
                "percent": "1",
                "pending_transaction": "$0.00",
                "overdue_transaction": "$0.00",
                "complete_transaction": "$3,300.00"
            }
        ]
    },
    "transactions": {
        "total": 15,
        "pending": 1,
        "completed": 9,
        "overdue": 5
    }
  }
=end


      def info
        if current_customer
          total = Transaction.where('(buyer_id = ? or seller_id = ?) and buyer_confirmed = ?', current_company.id, current_company.id, true).count
          pending = Transaction.where("(buyer_id = ? or seller_id = ?) AND due_date >= ? AND paid = ? AND buyer_confirmed = ?", current_company.id, current_company.id, Date.current, false, true).count
          overdue = Transaction.where("(buyer_id = ? or seller_id = ?) AND due_date < ? AND paid = ? AND buyer_confirmed = ?", current_company.id, current_company.id, Date.current, false, true).count
          completed = Transaction.where("(buyer_id = ? or seller_id = ?) AND paid = ? AND buyer_confirmed = ?", current_company.id, current_company.id, true, true).count

          @credit_given = CreditLimit.where('seller_id =?', current_company.id)
          @credit_given_to = @credit_given.count
          @total_credit_given = overall_credit_given(current_company)
          @total_used_credit = overall_credit_spent_by_customer(current_company)
          @total_available_credit = credit_available(current_company)
          @total_pending_sent = Transaction.pending_sent_transaction(current_company.id).sum(:total_amount)
          @total_overdue_sent = Transaction.overdue_sent_transaction(current_company.id).sum(:total_amount)
          @total_complete_sent = Transaction.complete_sent_transaction(current_company.id).sum(:total_amount)
          @credit_given_transaction = Transaction.where('seller_id =?', current_company.id)

          @credit_recieved_transaction = Transaction.where('buyer_id =?', current_company.id)
          @total_pending_received = Transaction.pending_received_transaction(current_company.id).sum(:total_amount)
          @total_overdue_received = Transaction.overdue_received_transaction(current_company.id).sum(:total_amount)
          @total_complete_received = Transaction.complete_received_transaction(current_company.id).sum(:total_amount)
          @credit_recieved = CreditLimit.where('buyer_id =?', current_company.id)

          render json: {success: true,
                        sales: { credit_given_to: @credit_given_to,
                                 total_given_credit: @total_credit_given,
                                 total_used_credit: @total_used_credit,
                                 total_available_credit: @total_available_credit, sales: calculate_sales},
                        purchases: {credit_recieved_count: @credit_recieved.count,
                                    total_credit_received: number_to_currency(overall_credit_received(current_company)),
                                    purchases: cutomer_puchase},
                        transactions: {total: total, pending: pending,
                                                      completed: completed, overdue: overdue}}
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/customers/feedback_rating
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
              feedback_rating = Feedback.new(comment: params[:comment], star: params[:rating], params_attribute => feedback_on_model.id, customer_id: current_customer.id)
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

      def get_scores(score, market_score)
        [
            {
                name: 'Late Payment',
                user_score: score.late_payment,
                market_average: market_score.late_payment,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.late_payment, market_score.late_payment),
                rank: score.late_payment_rank
            },
            {
                name: 'Current Risk Score',
                user_score: score.current_risk,
                market_average: market_score.current_risk,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.current_risk, market_score.current_risk),
                rank: score.current_risk_rank
            },
            {
                name: 'Network Diversity',
                user_score: score.network_diversity,
                market_average: market_score.network_diversity,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.network_diversity, market_score.network_diversity),
                rank: score.network_diversity_rank
            },
            {
                name: 'Buyer Network Score',
                user_score: score.buyer_network,
                market_average: market_score.buyer_network,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.buyer_network, market_score.buyer_network),
                rank: score.buyer_network_rank
            },
            {
                name: 'Due Date Score',
                user_score: score.due_date,
                market_average: market_score.due_date,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.due_date, market_score.due_date),
                rank: score.due_date_rank
            },
            {
                name: 'Credit Used Score',
                user_score: score.credit_used,
                market_average: market_score.credit_used,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.credit_used, market_score.credit_used),
                rank: score.credit_used_rank
            },
            {
                name: 'Number Of Suppliers Giving You Credit',
                user_score:  score.count_of_credit_given,
                market_average: market_score.count_of_credit_given,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.count_of_credit_given, market_score.count_of_credit_given),
                rank: score.count_of_credit_given_rank
            }
        ]
      end

      def get_seller_scores(score, market_score)
        [
            {
                name: 'Late Payment',
                user_score: score.late_payment,
                market_average: market_score.late_payment,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.late_payment, market_score.late_payment),
                rank: score.seller_late_payment_rank
            },
            {
                name: 'Current Risk Score',
                user_score: score.current_risk,
                market_average: market_score.current_risk,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.current_risk, market_score.current_risk),
                rank: score.seller_current_risk_rank
            },
            {
                name: 'Network Diversity',
                user_score: score.network_diversity,
                market_average: market_score.network_diversity,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.network_diversity, market_score.network_diversity),
                rank: score.seller_network_diversity_rank
            },
            {
                name: 'Seller Network Score',
                user_score: score.seller_network,
                market_average: market_score.seller_network,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.seller_network, market_score.seller_network),
                rank: score.seller_network_rank
            },
            {
                name: 'Due Date Score',
                user_score: score.due_date,
                market_average: market_score.due_date,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.due_date, market_score.due_date),
                rank: score.seller_due_date_rank
            },
            {
                name: 'Credit Used Score',
                user_score: score.credit_used,
                market_average: market_score.credit_used,
                user_score_vs_market_score: ApplicationHelper.safe_divide_float(score.credit_used, market_score.credit_used),
                rank: score.seller_credit_used_rank
            }
        ]
      end

      def get_current_cisk_score(buyer_score, market_buyer_score)
      end

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
