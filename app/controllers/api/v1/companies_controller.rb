class Api::V1::CompaniesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token, :current_customer, except: [:check_company, :country_list, :companies_list]
  helper_method :current_company

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include ApplicationHelper

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

  def check_company
    company = Company.where(name: params[:company_name]).present?
    render json: { request_acess: company, signup: !company }
  end

  def country_list
    countries = Company.all.map { |e| e.county }.compact.reject { |e| e.to_s == "" }.uniq
    render json: { success: true, countries: countries }
  end

  def companies_list
    companies = Company.where(county: params[:country])
    render json: { success: true, companies: companies.as_json(only: [:id, :name, :county]) }
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized unless current_customer.present?
  end

  def not_found
    render json: {errors: 'Not found', response_code: 201 }, status: 404
  end

  def history
    if current_company
      history = []
      all_rough_pend_transactions = []
      all_rough_over_transactions = []
      all_rough_comp_transactions = []
      polish_pending_transactions = []
      polish_overdue_transactions = []
      polish_completed_transactions = []
      @all_rough_transaction = Transaction.includes(:trading_parcel).where('(buyer_id = ? or seller_id = ?) and diamond_type != ?', current_company.id, current_company.id, 'Polished')
      @all_polished_transaction = Transaction.includes(:trading_parcel).where('(buyer_id = ? or seller_id = ?) and diamond_type = ?', current_company.id, current_company.id, 'Polished')
      @all_rough_transaction.each do |t|
        data = {
          id: t.id,
          buyer_id: t.buyer_id,
          seller_id: t.seller_id,
          trading_parcel_id: t.trading_parcel_id,
          due_date: t.due_date,
          avg_price: t.price,
          credit: t.credit,
          paid: t.paid,
          created_at: t.created_at,
          invoice_date: t.created_at.strftime("%B, %d %Y"),
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
          payment_status: get_status(t),
          no_of_stones: t.trading_parcel.present? ? t.trading_parcel.no_of_stones : 'N/A',
          carats: t.trading_parcel.present? ? number_with_precision(t.trading_parcel.weight, precision: 2) : 'N/A',
          cost: t.trading_parcel.present? ? t.trading_parcel.cost : 'N/A',
          box_value: t.trading_parcel.present? ? t.trading_parcel.box_value : 'N/A',
          sight: t.trading_parcel.present? ? t.trading_parcel.sight : 'N/A',
          comment: t.trading_parcel.present? ? t.trading_parcel.try(:comment) : 'N/A',
          confirm_status: t.buyer_confirmed
        }
        if t.paid == false
          other = {
            seller_days_limit: (current_company.id == t.buyer_id) ?  get_days_limit(current_company, t.seller) : get_days_limit(t.buyer, current_company),
            buyer_days_limit: (Date.today - t.created_at.to_date).to_i,
            market_limit: (current_company.id == t.buyer_id) ?  number_to_currency(get_market_limit_from_credit_limit_table(current_company, t.seller)) : get_market_limit_from_credit_limit_table(t.buyer, current_company)
          }
          if t.due_date.present?
            data.merge!(other)
            if (t.due_date > Date.today)
              all_rough_pend_transactions << data
            else
              all_rough_over_transactions << data
            end
          end
        else
          all_rough_comp_transactions << data
        end
      end
      rough = {
        pending_transaction: all_rough_pend_transactions,
        overdue_transaction: all_rough_over_transactions,
        completed_transaction: all_rough_comp_transactions
      }

      @all_polished_transaction.each do |t|
        data = {
          id: t.id,
          buyer_id: t.buyer_id,
          seller_id: t.seller_id,
          trading_parcel_id: t.trading_parcel_id,
          due_date: t.due_date,
          avg_price: t.price,
          total_amount: t.total_amount,
          credit: t.credit,
          paid: t.paid,
          created_at: t.created_at,
          invoice_date: t.created_at.strftime("%B, %d %Y"),
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
          payment_status: get_status(t),
          invoice_date: t.created_at.strftime("%B, %d %Y"),
          description: get_description(t.trading_parcel),
          no_of_stones: t.trading_parcel.present? ? t.trading_parcel.no_of_stones : 'N/A',
          carats: t.trading_parcel.present? ? number_with_precision(t.trading_parcel.weight, precision: 2) : 'N/A',
          cost: t.trading_parcel.present? ? t.trading_parcel.cost : 'N/A',
          box_value: t.trading_parcel.present? ? t.trading_parcel.box_value : 'N/A',
          sight: t.trading_parcel.present? ? t.trading_parcel.sight : 'N/A',
          amount_to_be_paid: t.remaining_amount,
          comment: t.trading_parcel.present? ? t.trading_parcel.try(:comment) : 'N/A',
          confirm_status: t.buyer_confirmed
        }
        if t.paid == false
          other = {
            seller_days_limit: (current_company.id == t.buyer_id) ?  get_days_limit(current_company, t.seller) : get_days_limit(t.buyer, current_company),
            buyer_days_limit: (Date.today - t.created_at.to_date).to_i,
            market_limit: (current_company.id == t.buyer_id) ?  number_to_currency(get_market_limit_from_credit_limit_table(current_company, t.seller)) : get_market_limit_from_credit_limit_table(t.buyer, current_company)
          }
          if t.due_date.present?
            data.merge!(other)
            if (t.due_date > Date.today)
              polish_pending_transactions << data
            else
              polish_overdue_transactions << data
            end
          end
        else
          polish_completed_transactions << data
        end
      end
      polished = {
        pending_transaction: polish_pending_transactions,
        overdue_transaction: polish_overdue_transactions,
        completed_transaction: polish_completed_transactions
      }
      history = {
        rough: rough,
        polished: polished
      }
      render :json => {:success => true, :history=> history, response_code: 200 }
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
end
