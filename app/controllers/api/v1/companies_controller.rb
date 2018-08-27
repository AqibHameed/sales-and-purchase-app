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
      @all_transaction = Transaction.includes(:trading_parcel)
      @all_transaction.each do |t|
        data = {
          id: t.id,
          buyer_id: t.buyer_id,
          seller_id: t.seller_id,
          trading_parcel_id: t.trading_parcel_id,
          due_date: t.due_date,
          price: t.price,
          credit: t.credit,
          paid: t.paid,
          created_at: t.created_at,
          updated_at: t.updated_at,
          buyer_confirmed: t.buyer_confirmed,
          reject_reason: t.reject_reason,
          reject_date: t.reject_date,
          transaction_type: t.transaction_type,
          remaining_amount: t.remaining_amount,
          transaction_uid: t.transaction_uid,
          diamond_type: t.diamond_type,
          total_amount: t.total_amount,
          invoice_no: t.invoice_no,
          ready_for_buyer: t.ready_for_buyer,
          description: t.description,
          activity: t.seller.try(:name),
          counter_party: t.buyer.try(:name),
          payment_status: get_status(t),
          shape:  t.trading_parcel.present? ? (t.trading_parcel.shape.present? ? t.trading_parcel.shape : 'N/A') : 'N/A'
        }
        if (t.buyer_id == current_company.id  || t.seller_id == current_company.id) && (t.paid == false)
          if t.due_date.present?
            if (t.due_date > Date.today)
              if t.diamond_type == 'Polished'
                polish_pending_transactions << data
              else
                all_rough_pend_transactions << data
              end
            else
              if t.diamond_type == 'Polished'
                polish_overdue_transactions << data
              else
                all_rough_over_transactions << data
              end
            end
          end
        else
          if t.diamond_type == 'Polished'
            polish_completed_transactions << data
          else
            all_rough_comp_transactions << data
          end
        end
      end
      rough = {
        pending_transaction: all_rough_pend_transactions,
        overdue_transaction: all_rough_over_transactions,
        completed_transaction: all_rough_comp_transactions
      }
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
