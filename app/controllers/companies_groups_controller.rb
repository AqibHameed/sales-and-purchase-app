class CompaniesGroupsController < ApplicationController
  before_action :check_compaines_group_customers, only: [:create]

  def index
  end

  def new
    @companies_group = CompaniesGroup.new
  end

  def create
    if @result
      @current_ids.each do |customer_id|
        CompaniesGroup.create(group_name: params[:companies_group][:group_name], seller_id: current_customer.id, customer_id: customer_id)
      end
      flash[:notice] = "Group created successfully."
      redirect_to credit_suppliers_path
    else
      flash[:alert] = "Customer already present in different group"
      redirect_to new_companies_group_path
    end
  end

  def destroy
    companies_group = CompaniesGroup.find_by(id: params[:id])
    companies_group.destroy
    flash[:notice] = 'Customer was successfully destroyed.'
    redirect_to new_companies_group_path
  end

  private
    def check_compaines_group_customers
      @result  = true
      customer_ids = CompaniesGroup.all.map(&:customer_id)
      @current_ids = params[:companies_group][:customer_id].delete_if(&:blank?)
      @current_ids.each do |customer_id|
        @result = false if customer_ids.include?(customer_id.to_i)
      end
    end
end
