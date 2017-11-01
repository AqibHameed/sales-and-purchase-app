class CompaniesController < ApplicationController

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
end
