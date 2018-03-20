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

  def save_limit
    customer = Customer.find( params[:sub_company_credit_limit][:id])

    @sub_company_limit = SubCompanyCreditLimit.where(sub_company_id: customer.id).first
    if @sub_company_limit.nil?
      @sub_company_limit = SubCompanyCreditLimit.new(sub_company_limit_params)
      if @sub_company_limit.save
        set_limit_customers(@sub_company_limit, 'new')
        @success = true
      else
        @errors = @sub_company_limit.errors.full_messages
      end
    else
      type = @sub_company_limit.try(:credit_type)
      if @sub_company_limit.update_attributes(sub_company_limit_params)
        set_limit_customers(@sub_company_limit, type)
        @success = true
      else
        @errors = @sub_company_limit.errors.full_messages
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def set_limit_customers(object, type)
    @subcompanycustomer = SubCompanyCustomer.where(sub_company_credit_limit_id: object.id)
    unless type == 'Specific' && params[:sub_company_credit_limit][:credit_type] == 'Specific'
      @subcompanycustomer.destroy_all
    end
    if params[:sub_company_credit_limit][:credit_type] == 'Specific'
      cust_ids = params[:sub_company_credit_limit][:customer_id].split(',')
      cust_ids.each do |cust_id|
        sc_cust = SubCompanyCustomer.find_by(customer_id: cust_id, sub_company_credit_limit_id: object.id)
        if sc_cust.present?
          sc_cust.update(credit_limit: params[:sub_company_credit_limit][:credit_limit])
        else
          SubCompanyCustomer.create(customer_id: cust_id, sub_company_credit_limit_id: object.id, credit_limit: params[:sub_company_credit_limit][:credit_limit])
        end
      end
    else
      SubCompanyCustomer.create(sub_company_credit_limit_id: object.id, credit_limit: params[:sub_company_credit_limit][:credit_limit])
    end
  end

  def set_limit
    @customer = Customer.find(params[:id])
    @sub_company_limit = SubCompanyCreditLimit.where(sub_company_id: @customer.id).first
    if @sub_company_limit.nil?
      @sub_company_limit = SubCompanyCreditLimit.new
    end
    respond_to do |format|
      format.js
    end
  end

  private
  def sub_company_limit_params
    params.require(:sub_company_credit_limit).permit(:parent_id, :credit_type, :sub_company_id, :id)
  end
end