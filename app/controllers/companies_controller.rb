class CompaniesController < ApplicationController
  before_action :authenticate_customer!, except: [:country_company_list]
  
  def list_company
    if params[:name].present?
      @companies = Customer.where('lower(company) LIKE ?', "%#{params[:name].downcase}%").where.not(id: current_customer.id)
    end
  end

  def company_limits
    cl = CreditLimit.where(buyer_id: params[:credit_limit][:buyer_id], supplier_id: params[:credit_limit][:supplier_id]).first_or_initialize
    if cl.credit_limit.nil?
      cl.credit_limit = params[:credit_limit][:credit_limit]
    else
      cl.credit_limit = cl.credit_limit + params[:credit_limit][:credit_limit].to_f
    end
    cl.market_limit = params[:credit_limit][:market_limit]
    if cl.save
      redirect_to list_company_companies_path
    end
  end

  def index
    @company = Company.all
  end

  def secure_center
    @secure_center = SecureCenter.new
  end

  def download_secure_center
    if params[:company].present?
      @company = Company.where(name: params[:company]).first
      @secure_centers = SecureCenter.where("seller_id = ? AND buyer_id = ?", current_company.id, @company.id)
      respond_to do |format|
        format.xlsx 
      end
    else
      flash[:notice] = "Please select a company!!!"
      render :secure_center
    end
  end

  ### Not in use
  def check_company
    if Company.where(name: params[:name]).exists?
      render json: { success: true }
    else
      render json: { success: false }
    end
  end
  ###

  def country_company_list
    @company = Company.where(county: params[:name])
    respond_to do |format|
      format.js
    end
  end
end
