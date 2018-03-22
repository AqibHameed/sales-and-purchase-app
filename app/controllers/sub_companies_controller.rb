class SubCompaniesController < ApplicationController
  require 'ostruct'

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
    customer = Customer.find(params[:sub_company_credit_limit][:id])

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
    @creditlimits = CreditLimit.where(supplier_id: object.try(:sub_company_id))
    unless type == 'Specific' && params[:sub_company_credit_limit][:credit_type] == 'Specific'
      @creditlimits.destroy_all
    end
    if params[:sub_company_credit_limit][:credit_type] == 'Specific'
      cust_ids = params[:sub_company_credit_limit][:customer_id].split(',')
      cust_ids.each do |cust_id|
        credit_limit = CreditLimit.where(buyer_id: cust_id, supplier_id: params[:sub_company_credit_limit][:sub_company_id]).first_or_initialize
        credit_limit.credit_limit = params[:sub_company_credit_limit][:credit_limit].to_f
        credit_limit.save!
      end
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

  def show_all_customers
    scc_limits = SubCompanyCreditLimit.find_by(id: params[:id])
    sccs = CreditLimit.where(supplier_id: scc_limits.try(:sub_company_id))
    @customers = []
    sccs.each do |scc|
      object = OpenStruct.new
      object.customer = Customer.find_by(id: scc.try(:buyer_id))
      object.credit_limit =scc.try(:credit_limit)
      object.sub_company_customer_id =scc.try(:id)
      object.sub_company_credit_limit_id =params[:id]
      @customers << object
    end
  end

  def remove_customer_limit
    sub_company_customer = CreditLimit.find_by(id: params[:id])
    sub_company_customer.destroy
    respond_to do |format|
      format.html { redirect_to show_all_customers_sub_company_url(params[:sub_company_credit_limit_id]), notice: 'Customer was successfully destroyed.' }
    end
  end

  private
  def sub_company_limit_params
    params.require(:sub_company_credit_limit).permit(:parent_id, :credit_type, :sub_company_id, :id, :credit_limit)
  end
end