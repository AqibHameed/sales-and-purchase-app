class SubCompaniesController < ApplicationController

  def index
    @sub_companies = Customer.where(parent_id: current_customer.id)
  end

  def invite
  end

  def send_invite
    begin
      Customer.invite!(:email => params[:email])
      customer = Customer.unscoped.last
      customer.parent_id = current_customer.id
      customer.save(validate: false)
      flash[:notice] = "Sub company invited successfully."
      redirect_to invite_sub_companies_path
    rescue
      flash[:notice] = "There was some error. Please try again"
      redirect_to invite_sub_companies_path
    end
  end

  def limit
    @customer = Customer.find(params[:id])
    @sub_company_limit = SubCompanyCreditLimit.where(customer_id: @customer.id).first
    if @sub_company_limit.nil?
      @sub_company_limit = SubCompanyCreditLimit.new
    end
  end

  def save_limit
    customer = Customer.find(params[:id])
    @sub_company_limit = SubCompanyCreditLimit.where(customer_id: customer.id).first
    if @sub_company_limit.nil?
      @sub_company_limit = SubCompanyCreditLimit.new(sub_company_limit_params)
      if @sub_company_limit.save
        flash[:notice] = "Limit added successfully."
        redirect_to sub_companies_path
      else
        render :limit
      end
    else
      if @sub_company_limit.update_attributes(sub_company_limit_params)
        flash[:notice] = "Limit updated successfully."
        redirect_to sub_companies_path
      else
        render :limit
      end
    end
  end

  private
  def sub_company_limit_params
    params.require(:sub_company_credit_limit).permit(:customer_id, :parent_id, :credit_limit)
  end
end