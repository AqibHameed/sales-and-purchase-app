class Api::V1::CompaniesController < ApplicationController
  include LiveMonitor
  skip_before_action :verify_authenticity_token
  before_action :check_token, :current_customer, except: [:check_company, :country_list, :companies_list]
  helper_method :current_company

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

  def blocked_customers
    if current_company
      blocked = BlockUser.where(company_id: current_company.id)
      render json: { success: true, blocked_customers: blocked.map { |e| { id: e.try(:block_user).try(:id).to_s, company: e.block_user.try(:name), city: e.block_user.try(:city), country: e.block_user.try(:county), created_at: e.block_user.try(:created_at), updated_at: e.block_user.try(:updated_at)}}, response_code: 200 }
    end
  end

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

  def seller_companies
    if current_company
      #transactions =  current_company.seller_transactions.select('buyer_id').where("paid = ?", false)
      transactions = Company.select("
              companies.id,
              count(companies.id) as transaction_count,
              companies.name,
              sum(t.remaining_amount) as remaining_amount
      ").joins("inner join transactions t on (companies.id = t.buyer_id and t.seller_id = #{current_company.id} and t.buyer_confirmed = true and t.paid = 0 and t.due_date != #{Date.current} )")
      .group(:id)
      .order(:id)

      result = []
      if transactions.present?
        transactions.uniq.each do |t|
          data = {
            id: t.id,
            name: t.name,
            transaction_count: t.transaction_count,
            remaining_amount: t.remaining_amount,
            overdue_status: current_company.has_overdue_that_seller_setlimit(t.id)
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

  def history
    transactions = []
    if current_company
      company = Company.where(name: params[:company]).first
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
          avg_price: t.price.to_f,
          total_amount: t.total_amount.to_f,
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
          cost: t.trading_parcel.present? ? cost_convert(t.trading_parcel) : 'N/A',
          box_value: t.trading_parcel.present? ? t.trading_parcel.box_value : 'N/A',
          sight: t.trading_parcel.present? ? t.trading_parcel.sight : 'N/A',
          amount_to_be_paid: t.remaining_amount.to_f,
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
          amount_to_be_paid: t.remaining_amount.to_f,
          transaction_uid: t.transaction_uid,
          diamond_type: t.diamond_type,
          total_amount: t.total_amount.to_f,
          invoice_no: t.invoice_no,
          ready_for_buyer: t.ready_for_buyer,
          description: get_description(t.trading_parcel),
          activity: (current_company.id == t.buyer_id) ? 'Bought' : ((current_company.id == t.seller_id) ? 'Sold' : 'N/A'),
          counter_party: (current_company.id == t.buyer_id) ? t.seller.try(:name) : ((current_company.id == t.seller_id) ? t.buyer.try(:name) : 'N/A'),
          payment_status: t.buyer_reject ? 'Rejected' : get_status(t),
          no_of_stones: t.trading_parcel.present? ? t.trading_parcel.no_of_stones : 'N/A',
          carats: t.trading_parcel.present? ? t.trading_parcel.weight.to_f : 'N/A',
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


  def cost_convert trading_parcel
   trading_parcel.cost.blank? ? nil: trading_parcel.cost.to_f
  end

=begin
 @apiVersion 1.0.0
 @api {get} api/v1/secure_center?id=buyer_id
 @apiName live_monitoring
 @apiGroup companies_controller
 @apiDescription get secure center data for buyer
 @apiSuccessExample {json} SuccessResponse:
  {
    "success": true,
    "details": {
        "id": 245,
        "invoices_overdue": 0,
        "paid_date": null,
        "buyer_id": 7177,
        "seller_id": 7187,
        "outstandings": "0.0",
        "overdue_amount": "0.0",
        "last_bought_on": null,
        "buyer_percentage": "0.0",
        "system_percentage": "0.0",
        "supplier_connected": 0
    }
  }
=end

  def live_monitoring
    if current_company
      #secure_center_record(current_company.id, params[:id])
      @secure_center = SecureCenter.where("seller_id = ? AND buyer_id = ? ", current_company.id, params[:id]).last
      if @secure_center.present?
        render status: :ok, template: "api/v1/companies/secure_center"
        #render json: { success: true, details: secure_center }
      else
        company = Company.where(id: params[:id]).first
        if company.present?
          @secure_center = save_secure_center(company)
          render status: :ok, template: "api/v1/companies/secure_center"
        else
          render json: { errors: "Company with this id does not present.", response_code: 201 }
        end
      end
    else
      render json: { errors: "Not authenticated", response_code: 201 }
    end  
  end
  
  protected
  def current_company
    @company ||= current_customer.company
  end

  private
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

  def save_secure_center(company)
    data = get_secure_center_record(company, current_company)
    data.merge!(buyer_id: company.id)
    data.merge!(seller_id: current_company.id)
    secure_center = SecureCenter.new(data)
    secure_center.save
    return secure_center
  end

end
