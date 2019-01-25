class Api::V1::CompaniesController < ApplicationController
  include LiveMonitor
  skip_before_action :verify_authenticity_token
  before_action :check_token, :current_customer, except: [:check_company, :country_list, :companies_list]
  helper_method :current_company
  before_action :check_current_company, only: [:send_security_data_request]
  before_action :check_request, only: [:accept_secuirty_data_request, :reject_secuirty_data_request]
  # before_action :seller_companies_permission, only: [:seller_companies]
  before_action :live_monitoring_permission, only: [:live_monitoring]

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include ApplicationHelper
  include SecureCenterHelper

  def list_company
    @array =[]
    current_customer.companies.each do |company|
      hash = {}
      hash[:company_name] = company.name
      if company.credit_limit.present? && company.market_limit.present?
      hash[:credit_limit] = company.credit_limit
      hash[:market_limit] = company.market_limit
      else
        hash[:credit_limit] = "you need to set first"
        hash[:market_limit] = "you need to set first"
      end
      @array.push(hash)
    end
    render :json => {:success => true, :company=> @array, response_code: 200 }
  end

  def current_customer
      token = request.headers['Authorization'].presence
       if token
         @current_customer ||= Customer.find_by_authentication_token(token)
       end
  end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/blocked_customers
 @apiSampleRequest off
 @apiName blocked customers
 @apiGroup Companies
 @apiDescription get blocked Customer
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "blocked_customers": [
        {
            "id": "1",
            "company": "Dummy co. 1",
            "city": null,
            "country": "India",
            "created_at": "2018-10-25T11:21:17.000Z",
            "updated_at": "2018-10-25T11:21:17.000Z"
        }
    ],
    "response_code": 200
}
=end

  def blocked_customers
    if current_company
      blocked = BlockUser.where(company_id: current_company.id)
      render json: { success: true, blocked_customers: blocked.map { |e| { id: e.try(:block_user).try(:id).to_s, company: e.block_user.try(:name), city: e.block_user.try(:city), country: e.block_user.try(:county), created_at: e.block_user.try(:created_at), updated_at: e.block_user.try(:updated_at)}}, response_code: 200 }
    end
  end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/reset_limits
 @apiSampleRequest off
 @apiName reset limits
 @apiGroup Companies
 @apiDescription reset limit against compnay
 @apiParamExample {json} Request-Example:
{
"company_id": 1
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": "Limits are reset successfully",
    "response_code": 200
}
=end

  def reset_limits
    if current_company
      company = Company.where(id: params[:company_id]).first
      if company.present?
        credit_limit = CreditLimit.where(buyer_id: company.id, seller_id: current_company.id).first_or_create
        days_limit = DaysLimit.where(buyer_id: company.id, seller_id: current_company.id).first_or_create
        credit_limit.credit_limit = 0
        credit_limit.save
        days_limit.days_limit = 30
        days_limit.save
        render json: { success: true, message: "Limits are reset successfully", response_code: 200 }
      else
        render json: { errors: "Company does not exist for this id.", response_code: 201 }
      end
    else
      render json: { errors: "Not authenticated", response_code: 201 }
    end
  end

  def check_company
    company = Company.where(name: params[:company_name]).present?
    render json: { request_acess: company, signup: !company }
  end

  def country_list
    countries = Company.all.map { |e| e.county }.compact.reject { |e| e.to_s == "" }.uniq
    render json: { success: true, countries: countries }
  end

  def companies_list
    companies = Company.where(county: params[:country]) #.page(params[:page]).per(params[:per])
    render json: { success: true, companies: companies.as_json(only: [:id, :name, :county]) }
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized unless current_customer.present?
  end

  def not_found
    render json: {errors: 'Not found', response_code: 201 }, status: 404
  end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/invite
 @apiSampleRequest off
 @apiName invite
 @apiGroup Companies
 @apiDescription invite company
 @apiParamExample {json} Request-Example:
{
 "company": "test_test",
 "email": "hello@123.com",
 "country": "India"
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": " Company is invited successfully",
    "response_code": 200
}
=end

  def invite
    if current_company
      company = Company.new(name: params[:company], county: params[:country])
      if company.save
        CustomerMailer.send_invitation(params[:email]).deliver
        render json: { success: true, message: " Company is invited successfully", response_code: 200 }
      else
        render json: { success: false, message: company.errors.full_messages }
      end
    else
      render json: { errors: "Not authenticated", response_code: 201 }
    end
  end

  def send_feedback
    if current_company
      CustomerMailer.send_feedback(current_customer.name, params[:star], params[:comment]).deliver
      render json: { success: true, message: " Feedback is submitted successfully", response_code: 200 }
    else
      render json: { errors: "Not authenticated", response_code: 201 }
    end
    end
=begin
    @apiVersion 1.0.0
    @api {post} /api/v1/seller_companies
    @apiSampleRequest off
    @apiName seller_companies
    @apiGroup Companies
    @apiDescription shows the list of companies
    @apiSuccessExample {json} SuccessResponse1:
     {
        "errors": "permission Access denied",
        "response_code": 201
     }
    @apiSuccessExample {json} SuccessResponse:
    {
      "success": true,
      "pagination": {
          "total_pages": 1,
          "prev_page": null,
          "next_page": null,
          "current_page": 1
      },
      "companies": [
          {
              "id": 7,
              "name": "Dummy Buyer 1",
              "transaction_count": 5,
              "amount_due": "10975.29",
              "overdue_status": true
          },
          {
              "id": 10,
              "name": "Dummy Buyer 2",
              "transaction_count": 1,
              "amount_due": "3300.0",
              "overdue_status": true
          }
      ]
   }
=end


  def seller_companies
    if current_company
      #transactions =  current_company.seller_transactions.select('buyer_id').where("paid = ?", false)
      companies = Company.select("
              companies.id,
              count(companies.id) as transaction_count,
              companies.name,
              sum(t.remaining_amount) as remaining_amount
      ").joins("inner join transactions t on (companies.id = t.buyer_id and t.seller_id = #{current_company.id} and t.buyer_confirmed = true and t.paid = 0 and t.due_date != #{Date.current} )"
      ).group(:id)
      .order(:id)

      result = []
      if companies.present?
        companies.uniq.each do |company|
          company_transactions = company.buyer_transactions
          if company_transactions.present?
            company_transactions_with_current_seller = company_transactions.where(seller_id: current_company.id)
          end
          data = {
            id: company.id,
            name: company.name,
            transaction_count: company.transaction_count,
            remaining_amount: company.remaining_amount,
            amount_due: company_transactions_with_current_seller.present? ? company_transactions_with_current_seller.where("paid = ? AND buyer_confirmed = ?", false, true).sum(:remaining_amount).round(2) : 0.0,
            overdue_status: current_company.has_overdue_that_seller_setlimit(company.id)
          }
          result << data
        end
      end
      @companies = Kaminari.paginate_array(result).page(params[:page]).per(params[:count])
      render json: {success: true, pagination: set_pagination(:companies), companies: @companies}
    else
      render json: {errors: "Not authenticated", response_code: 201}
    end
  end

=begin
  @apiVersion 1.0.0
  @api {get} /api/v1/companies_review
  @apiSampleRequest off
  @apiName companies_review
  @apiGroup Companies
  @apiDescription review the companies
  @apiParamExample {json} Request-Example:
    {
     company_id: 1,
     know: true,
     trade: false,
     recommend: true,
     experience: true
    }
    @apiSuccessExample {json} SuccessResponse:
    {
      "review": {
          "id": 1,
          "know": true,
          "trade": false,
          "recommend": true,
          "experience": true
      },
      "response_code": 200
    }
=end

  def companies_review
    if current_customer
      review = Review.find_by(company_id: params[:company_id], customer_id: current_customer.id)
      if review.present?
        review.update_attributes(review_params)
        render :json => {review: review(review), response_code: 201}
      else
        review_company = Review.new(review_params)
        if review_company.save
          render :json => {review: review(review_company), response_code: 200}
        else
          render json: {success: false, errors: review_company.errors.full_messages}
        end
      end
    else
      render json: {errors: "Not authenticated", response_code: 401}
    end
  end

=begin
  @apiVersion 1.0.0
  @api {get} /api/v1/count_companies_review
  @apiSampleRequest off
  @apiName count_companies_review
  @apiGroup Companies
  @apiDescription count the companies review questions
  @apiParamExample {json} Request-Example:
  {
    "success": true,
    "companies_rated_count": {
        "know": {
            "yes": 1,
            "no": 0
        },
        "trade": {
            "yes": 0,
            "no": 1
        },
        "recommend": {
            "yes": 0,
            "no": 0
        },
        "experience": {
            "yes": 0,
            "no": 0
        },
        "total_number_of_comapnies_rated": 1
    }
  }
=end

  def count_companies_review
    if current_company
       current_companies_review = Review.where(company_id: current_company.id)
       @yes_know = current_companies_review.where(know: true).count
       @not_know = current_companies_review.where(know: false).count
       @yes_trade = current_companies_review.where(trade: true).count
       @not_trade = current_companies_review.where(trade: false).count
       @yes_recommend = current_companies_review.where(recommend: true).count
       @not_recommend = current_companies_review.where(recommend: false).count
       @yes_experience = current_companies_review.where(experience: true).count
       @not_experience = current_companies_review.where(experience: false).count
       @total_number_of_comapnies_rated = current_companies_review.count

       render json: {success: true, companies_rated_count: companies_rated_count}
    else
      render json: {errors: "Not authenticated", response_code: 201}
    end
  end


=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/history
 @apiSampleRequest off
 @apiName history
 @apiGroup Companies
 @apiDescription get history of all transactions
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "pagination": {
        "total_pages": 1,
        "prev_page": null,
        "next_page": null,
        "current_page": 1
    },
    "transactions": [
        {
            "id": 10744,
            "buyer_id": 1,
            "seller_id": 3585,
            "trading_parcel_id": 10745,
            "due_date": "2018-11-23T18:30:00+00:00",
            "avg_price": "10.0",
            "credit": 30,
            "paid": false,
            "created_at": "2018-10-25T12:20:51.000Z",
            "invoice_date": "2018-10-25T12:20:51+00:00",
            "updated_at": "2018-10-25T12:20:51.000Z",
            "buyer_confirmed": true,
            "reject_reason": null,
            "reject_date": null,
            "transaction_type": "manual",
            "amount_to_be_paid": "100.0",
            "transaction_uid": "9ac4579796e01a860fad5c84",
            "diamond_type": "Rough",
            "total_amount": "100.0",
            "invoice_no": null,
            "ready_for_buyer": null,
            "description": "OutSide Goods Dummy Parcel for Demo",
            "activity": "Sold",
            "counter_party": "Dummy co. 1",
            "payment_status": "Overdue",
            "no_of_stones": null,
            "carats": "10.00",
            "cost": "10.0",
            "box_value": "12",
            "sight": "07/18",
            "comment": "This is a Demo Parcel",
            "confirm_status": true,
            "paid_date": null,
            "seller_days_limit": 30,
            "buyer_days_limit": 54
        }
    ]
}
=end

  def history
    transactions = []
    if current_company
      company = Company.find_by(name: params[:company]) if params[:company].present?
      unless company.present?
        company = nil
      end
      if params[:type] == 'polished'
        transactions << get_polished_transaction(company, params[:search], params[:status], params[:activity])
      elsif params[:type] == 'rough' 
        transactions << get_rough_transaction(company, params[:search], params[:status], params[:activity])
      else
        transactions << get_rough_transaction(company, params[:search], params[:status], params[:activity])
        transactions <<  get_polished_transaction(company, params[:search], params[:status], params[:activity])
      end
      @all_transactions = Kaminari.paginate_array(transactions.flatten).page(params[:page]).per(params[:count])
      render json: { success: true, pagination: set_pagination(:all_transactions), transactions: @all_transactions }
    else
    end
  end

  def get_polished_transaction(company, search, status, activity)
    @array = []
    no_of_overdue_transactions = current_company.buyer_transactions.where("due_date < ? AND paid = ?", Date.current, false).count
    @transactions = []
    @all_polished_transaction = Transaction.includes(:trading_parcel).where('(buyer_id = ? or seller_id = ?) and diamond_type = ? and cancel = ?', current_company.id, current_company.id, 'Polished', false)
    if company.present?
      @all_polished_transaction = @all_polished_transaction.where('buyer_id = ?', company.id)
    end
    if activity.present?
      @all_polished_transaction = @all_polished_transaction.where('buyer_id = ?', current_company.id) if activity == 'bought'
      @all_polished_transaction = @all_polished_transaction.where('seller_id = ?', current_company.id) if activity == 'sold'
    end
    if status.present?
      @transactions << @all_polished_transaction.where("due_date > ? && paid = ?", Date.current, false) if status.include? 'pending'
      @transactions << @all_polished_transaction.where("due_date < ? && paid = ?", Date.current, false) if status.include? 'overdue'
      @transactions << @all_polished_transaction.where("buyer_confirmed = ?", false) if status.include? 'awaiting confirmation'
      @transactions << @all_polished_transaction.where("paid = ?", true) if status.include? 'completed'
      @transactions << @all_polished_transaction if status.include? 'all'
    else
      @transactions << @all_polished_transaction
    end

    if @transactions.present?
      @transactions.flatten.uniq.each do |t|
        data = {
          id: t.id,
          buyer_id: t.buyer_id,
          seller_id: t.seller_id,
          trading_parcel_id: t.trading_parcel_id,
          due_date: t.due_date.present? ? t.due_date.strftime("%FT%T%:z") : 'N/A',
          avg_price: t.price,
          total_amount: t.total_amount,
          credit: t.credit,
          paid: t.paid,
          created_at: t.created_at,
          invoice_date: t.created_at.strftime("%FT%T%:z"),
          updated_at: t.updated_at,
          buyer_confirmed: t.buyer_confirmed,
          shape:  t.trading_parcel.present? ? (t.trading_parcel.shape.present? ? t.trading_parcel.shape : 'N/A') : 'N/A',
          size:  t.trading_parcel.present? ? (t.trading_parcel.weight.nil? ? 'N/A' : t.trading_parcel.weight) : 'N/A',
          color: t.trading_parcel.present? ? (t.trading_parcel.color.nil? ? 'N/A' : t.trading_parcel.color) : 'N/A',
          clarity: t.trading_parcel.present? ? (t.trading_parcel.clarity.nil? ? 'N/A' : t.trading_parcel.clarity) : 'N/A',
          cut: t.trading_parcel.present? ? (t.trading_parcel.cut.nil? ? (t.trading_parcel.polish.nil? ? (t.trading_parcel.symmetry.nil? ? 'N/A' : t.trading_parcel.symmetry[0..1]) : t.trading_parcel.polish[0..1]) : t.trading_parcel.cut[0..1]) : 'N/A',
          fluorescence: t.trading_parcel.present? ? (t.trading_parcel.fluorescence.nil? ? 'N/A' : t.trading_parcel.fluorescence) : 'N/A',
          lab: t.trading_parcel.present? ? (t.trading_parcel.lab.nil? ? 'N/A' : t.trading_parcel.lab) : 'N/A',
          activity: (current_company.id == t.buyer_id) ? 'Bought' : ((current_company.id == t.seller_id) ? 'Sold' : 'N/A'),
          counter_party: (current_company.id == t.buyer_id) ? t.seller.try(:name) : ((current_company.id == t.seller_id) ? t.buyer.try(:name) : 'N/A'),
          payment_status:  t.buyer_reject ? 'Rejected' : get_status(t),
          description: get_description(t.trading_parcel),
          no_of_stones: t.trading_parcel.present? ? t.trading_parcel.no_of_stones : 'N/A',
          carats: t.trading_parcel.present? ? t.trading_parcel.weight.to_f : 'N/A',
          cost: t.trading_parcel.present? ? cost_convert(t.trading_parcel)  : 'N/A',
          box_value: t.trading_parcel.present? ? t.trading_parcel.box_value : 'N/A',
          sight: t.trading_parcel.present? ? t.trading_parcel.sight : 'N/A',
          amount_to_be_paid: t.remaining_amount,
          comment: t.trading_parcel.present? ? t.trading_parcel.try(:comment) : 'N/A',
          confirm_status: t.buyer_confirmed
        }
        if current_company.id == t.buyer_id
          data.merge!(overdue_transactions: no_of_overdue_transactions)
        end
        if t.paid == false && t.due_date.present?
          other = {
              seller_days_limit: (current_company.id == t.buyer_id) ? get_days_limit(current_company, t.seller).to_i : get_days_limit(t.buyer, current_company).to_i,
              buyer_days_limit: (Date.current - t.created_at.to_date).to_i
          }
          data.merge!(other)
        end
        @array << data
      end
      return @array
    end
  end

  def get_rough_transaction(company, search, status, activity)
    @array = []
    no_of_overdue_transactions = current_company.buyer_transactions.where("due_date < ? AND paid = ?", Date.current, false).count

    @transactions = []

    @all_rough_transaction = Transaction.includes(:trading_parcel).where("diamond_type = ? OR diamond_type = ? OR diamond_type = ? OR diamond_type is null", 'Outside Goods', 'Rough', 'Sight').where('(buyer_id = ? or seller_id = ?) AND cancel = ?', current_company.id, current_company.id, false)
    if company.present?
      @all_rough_transaction = @all_rough_transaction.where('buyer_id = ?', company.id)
    end

    if activity.present?
      @all_rough_transaction = @all_rough_transaction.where('buyer_id = ? AND cancel = ?', current_company.id, false) if activity == 'bought'
      @all_rough_transaction = @all_rough_transaction.where('seller_id = ? AND cancel = ?', current_company.id, false) if activity == 'sold'
    end

    if status.present?
      @transactions << @all_rough_transaction.where("due_date > ? && paid = ? && buyer_confirmed = true", Date.current, false) if status.include? 'pending'
      @transactions << @all_rough_transaction.where("buyer_confirmed = ?", false) if status.include? 'awaiting confirmation'
      @transactions << @all_rough_transaction.where("due_date < ? && paid = ? && buyer_confirmed = true", Date.current, false) if status.include? 'overdue'
      @transactions << @all_rough_transaction.where("paid = ?", true) if status.include? 'completed'
      @transactions << @all_rough_transaction if status.include? 'all'
    else
      @transactions << @all_rough_transaction
    end

    if @transactions.present?
      @transactions.flatten.uniq.each do |t|
        data = {
          id: t.id,
          buyer_id: t.buyer_id,
          seller_id: t.seller_id,
          trading_parcel_id: t.trading_parcel_id,
          due_date: t.due_date.present? ? t.due_date.strftime("%FT%T%:z") : 'N/A',
          avg_price: t.price,
          credit: t.credit,
          paid: t.paid,
          created_at: t.created_at,
          invoice_date: t.created_at.strftime("%FT%T%:z"),
          updated_at: t.updated_at,
          buyer_confirmed: t.buyer_confirmed,
          reject_reason: t.reject_reason,
          reject_date: t.reject_date,
          transaction_type: t.transaction_type,
          amount_to_be_paid: t.remaining_amount,
          transaction_uid: t.transaction_uid,
          diamond_type: t.diamond_type,
          total_amount: t.total_amount,
          invoice_no: t.invoice_no,
          ready_for_buyer: t.ready_for_buyer,
          description: get_description(t.trading_parcel),
          activity: (current_company.id == t.buyer_id) ? 'Bought' : ((current_company.id == t.seller_id) ? 'Sold' : 'N/A'),
          counter_party: (current_company.id == t.buyer_id) ? t.seller.try(:name) : ((current_company.id == t.seller_id) ? t.buyer.try(:name) : 'N/A'),
          payment_status: t.buyer_reject ? 'Rejected' : get_status(t),
          no_of_stones: t.trading_parcel.present? ? t.trading_parcel.no_of_stones : 'N/A',
          carats: t.trading_parcel.present? ? number_with_precision(t.trading_parcel.weight, precision: 2) : 'N/A',
          cost: t.trading_parcel.present? ? cost_convert(t.trading_parcel)  : 'N/A',
          box_value: t.trading_parcel.present? ? t.trading_parcel.box_value : 'N/A',
          sight: t.trading_parcel.present? ? t.trading_parcel.sight : 'N/A',
          comment: t.trading_parcel.present? ? t.trading_parcel.try(:comment) : 'N/A',
          confirm_status: t.buyer_confirmed,
          paid_date: t.paid_date
        }
        if current_company.id == t.buyer_id
          data.merge!(overdue_transactions: no_of_overdue_transactions)
        end
        if t.paid == false && t.due_date.present?
          other = {
            seller_days_limit: (current_company.id == t.buyer_id) ?  get_days_limit(current_company, t.seller).to_i : get_days_limit(t.buyer, current_company).to_i,
            buyer_days_limit: (Date.current - t.created_at.to_date).to_i
          }
          data.merge!(other)
        end
        @array << data
      end
      return @array
    end
  end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/companies/send_security_data_request
 @apiName send_security_data_request
 @apiGroup companies_controller
 @apiDescription send request to show security data
 @apiParamExample {json} Request-Example:
{
	"receiver_id": 2
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": "Request send successfully.",
    "response_code": 201
}
=end

  def send_security_data_request
    live_monitor_request = PremissionRequest.find_or_initialize_by(sender_id: current_company.id, receiver_id: params[:receiver_id])
    if live_monitor_request.status == 'rejected'
      live_monitor_request.update_attributes(status: 2)
    end
    if live_monitor_request.save
      Message.send_request_for_live_monitoring(live_monitor_request)
      render json: {success: true,
                    message: "Request send successfully.",
                    response_code: 200}
    end
  end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/companies/accept_secuirty_data_request
 @apiName accept_secuirty_data_request
 @apiGroup companies_controller
 @apiDescription accept request to show security data
 @apiParamExample {json} Request-Example:
{
	"request_id": 9,
  "live_monitor":true,
  "buyer_score":true,
  "seller_score":false,
  "customer_info":true

}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": "Request accepted successfully.",
    "response_code": 200
}
=end

  def accept_secuirty_data_request
    request = PremissionRequest.find_by(id: params[:request_id])
    if request && request.status == 'pending'
      request.update_attributes(permission_params)
      request.update(status: 1)
    end
    render json: {success: true,
                  message: "Request accepted successfully.",
                  response_code: 200}
  end
  
=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/companies/reject_secuirty_data_request
 @apiName reject_secuirty_data_request
 @apiGroup companies_controller
 @apiDescription reject request to show security data
 @apiParamExample {json} Request-Example:
{
	"request_id": 9
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": "Request rejected successfully.",
    "response_code": 200
}
=end

  def reject_secuirty_data_request
    request = PremissionRequest.find_by(id: params[:request_id])
    if request && request.status == 'pending'
      request.update_attributes(status: 0)
    end
    render json: {success: true,
                  message: "Request rejected successfully.",
                  response_code: 200}
  end

  def cost_convert trading_parcel
    trading_parcel.cost.blank? ? nil: trading_parcel.cost.to_s
  end


=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/secure_center?receiver_id=2
 @apiSampleRequest off
 @apiName live_monitoring
 @apiGroup Companies
 @apiDescription get secure center data for buyer
 @apiSuccessExample {json} SuccessResponse1:
{
    "success": true,
    "details": {
        "id": 255,
        "buyer_id": 1,
        "seller_id": 4,
        "outstandings": 47000,
        "overdue_amount": 47000,
        "supplier_connected": 1,
        "permitted": false,
        "balance_credit_limit": 57000,
        "collection_ratio_days": [
            {
                "zer_percent": 0,
                "less_fiften": 1,
                "less_thirty": 0,
                "less_fourty_five": 0,
                "greater_fourty_five": 0
            }
        ],
        "paid_date": "2018-12-11"
    }
}
 @apiSuccessExample {json} SuccessResponse2:
{
    "success": true,
    "details": {
        "id": 263,
        "buyer_id": 1,
        "seller_id": 4,
        "supplier_connected": 10,
        "overdue_amount": 0,
        "invoices_overdue": 11,
        "outstandings": 0,
        "last_bought_on": "2019-01-22",
        "buyer_percentage": 0,
        "system_percentage": 30.61,
        "balance_credit_limit": 7000,
        "permitted": true,
        "number_of_seller_offer_credit": 2,
        "collection_ratio_days": {
            "zero_percent": 0,
            "less_fifteen": 1,
            "less_thirty": 0,
            "less_fourty_five": 0,
            "greater_fourty_five": 0
        },
        "buyer_score": 0,
        "paid_date": null
    }
}
=end

  def live_monitoring
    if current_company
      #secure_center_record(current_company.id, params[:id])
      @secure_center = SecureCenter.where("seller_id = ? AND buyer_id = ? ", current_company.id, params[:receiver_id]).last
      @credit_limit = CreditLimit.find_by(seller_id: current_company.id, buyer_id: params[:receiver_id])
      @number_of_seller_offer_credit_limit = CreditLimit.where(buyer_id: params[:receiver_id]).uniq.count
      company = Company.find_by(id: params[:receiver_id])
      @buyer_score =  company.get_buyer_score
      @seller_score = company.get_seller_score
      if @secure_center.present?
        render status: :ok, template: "api/v1/companies/secure_center.json.jbuilder"
        #render json: { success: true, details: secure_center }
      else
        if company.present?
          secure_center = SecureCenter.new(seller_id: current_company.id, buyer_id: company.id)
          @secure_center = create_or_update_secure_center(secure_center, company, current_company)
          render status: :ok, template: "api/v1/companies/secure_center.json.jbuilder"
        else
          render json: { errors: "Company with this id does not present.", response_code: 201 }
        end
      end
    else
      render json: { errors: "Not authenticated", response_code: 201 }
    end  
  end

=begin
  @apiVersion 1.0.0
  @api {get} /api/v1/companies/list_permission_companies
  @apiSampleRequest off
  @apiName list_permission_companies
  @apiGroup Companies
  @apiDescription list of companies who has given permission to view his financial data.
  @apiSuccessExample {json} SuccessResponse:
  {
    "success": true,
    "companies": [
        {
            "id": 8,
            "name": "Dummy Seller 1",
            "city": "",
            "county": "India",
            "created_at": "2018-12-06T09:12:54.000Z",
            "updated_at": "2018-12-06T09:12:54.000Z",
            "is_anonymous": false,
            "add_polished": false,
            "is_broker": false,
            "email": null,
            "deleted_at": null
        }
    ],
   "response_code": 200
  }
=end


  def list_permission_companies
    if current_company
        @companies = PremissionRequest.where(receiver_id: current_company.id, status: 1).map{|p|p.sender}
        render json: {success: true, companies: @companies, response_code: 200}
    else
      render json: {errors: "Not authenticated", response_code: 201}, status: :unauthorized
    end
  end

=begin
  @apiVersion 1.0.0
  @api {get} /api/v1/companies/remove_permission
  @apiSampleRequest off
  @apiName remove_permission
  @apiGroup Companies
  @apiDescription remove the permission of the company.
  @apiParamExample {json} Request-Example:
  {
    "company_id": 1,
    "live_monitor": false,
    "secure_center": false,
    "buyer_score": false,
    "seller_score": false,
    "customer_info": false
  }
  @apiSuccessExample {json} SuccessResponse:
  {
    "success": true,
    "message": "Request is removed successfully.",
    "response_code": 200
  }
=end

  def remove_permission
    if current_company
        premission_request = PremissionRequest.where(sender_id: params[:company_id], receiver_id: current_company.id, status: 1)
        if premission_request.present?
          premission_request.update_attributes(permission_params)
          render json: {success: true,
                        message: "Request is removed successfully.",
                        response_code: 200}
        else
          render json: {errors: "Request is not exist against this company.", response_code: 201}
        end
    else
      render json: {errors: "Not authenticated", response_code: 201}, status: :unauthorized
    end
  end


=begin
    @apiVersion 1.0.0
    @api {get} /api/v1/companies/show_review
    @apiSampleRequest off
    @apiName show_review
    @apiGroup Companies
    @apiDescription Show reviews  of the company.
        @apiParamExample {json} Request-Example:
        {
            "company_id": 4,
        }
    @apiSuccessExample {json} SuccessResponse:
      {
    "review": {
        "id": 7,
        "know": true,
        "trade": false,
        "recommend": true,
        "experience": false
    },
    "response_code": 200

=end





  def show_review
    if current_customer
      companies_review = Review.find_by(company_id: params[:company_id], customer_id: current_customer.id)
      if companies_review.present?
        render :json => {review: review(companies_review), response_code: 200}
      else
        render json: {errors: "Record not Found", response_code: 404}
      end
    else
      render json: {errors: "Not authenticated", response_code: 201}
    end
  end


  protected
  def current_company
    @company ||= current_customer.company unless current_customer.nil?
  end

  private

  def check_request
    if current_company
      request = PremissionRequest.find_by(id: params[:request_id])
      unless request.receiver_id == current_company.id
        render json: { errors: "you don't have permission perform this action", response_code: 201 }
      end
    else
      render json: { errors: "Not authenticated", response_code: 201 }
    end
  end

  def check_current_company
    if current_company.nil?
      render json: { errors: "Not authenticated", response_code: 201 }
    end
  end

  def check_token
    if request.headers["Authorization"].blank?
      render json: {msg: "Unauthorized Request", response_code: 201 }
    end
  end

  def set_pagination(name, options = {})
    results = instance_variable_get("@#{name}")
    page = {}
    pagination = {}
    if results.current_page <= results.total_pages
      request_params = request.query_parameters
      url_without_params = request.original_url.slice(0..(request.original_url.index("?")-1)) unless request_params.empty?
      url_without_params ||= request.original_url
      page[:first] = 1 if results.total_pages > 1 && !results.first_page?
      page[:last]  = results.total_pages  if results.total_pages > 1 && !results.last_page?
      page[:next]  = results.current_page + 1 unless results.last_page?
      page[:prev]  = results.current_page - 1 unless results.first_page?
      page.each do |k, v|
        page[k] = "#{url_without_params}?page=#{v}#{url_params}"
      end
      pagination = {
        total_pages: results.total_pages,
        prev_page: page[:prev].present? ? page[:prev].to_s : nil,
        next_page: page[:next].present? ? page[:next].to_s : nil,
        current_page: results.current_page
      }
    end
  end

  def url_params
    url = request.url
    uri = URI(url)
    params = CGI.parse(uri.query || "")
    params.delete('page')
    uri.query = URI.encode_www_form(params)
    query = ''
    query = '&'+uri.query unless uri.query.blank?
  end

  def review_params
    params.permit(:company_id, :know, :trade, :recommend, :experience).merge(customer_id: current_user.id)
  end

  def permission_params
    params.permit(:live_monitor, :secure_center, :buyer_score, :seller_score, :customer_info)
  end


  def review(review_company)
    {
        id: review_company.id,
        know: review_company.know,
        trade: review_company.trade,
        recommend: review_company.recommend,
        experience: review_company.experience
    }
  end

  def companies_rated_count
    {
        know:{
            yes: @yes_know,
            no: @not_know
        },
        trade:{
            yes: @yes_trade,
            no: @not_trade
        },
        recommend:{
            yes: @yes_recommend,
            no: @not_recommend
        },
        experience:{
            yes: @yes_experience,
            no: @not_experience
        },
        total_number_of_comapnies_rated: @total_number_of_comapnies_rated
    }
  end





end
