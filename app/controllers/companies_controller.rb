class CompaniesController < ApplicationController

	def list_company
    if params[:name].present?
      @companies = Company.where('name LIKE ?', "%#{params[:name]}%")
    # else
    #   @companies = Company.all
    end

  end

  def company_limits
  	@company_limit = Company.find(params[:company][:company_id])
  	@company_limit.update_attributes(credit_limit: params[:company][:credit_limit],market_limit: params[:company][:market_limit])
    if @company_limit.save
    	redirect_to list_company_companies_path
    else
    	redirent_to company_limits_companies_path
    end
  end

  def index
  	@company = Company.all
  end

end
