class CompaniesGroupsController < ApplicationController
  # before_action :check_compaines_group_customers, only: [:create]

  def index
  end

  def new
    @companies_group = CompaniesGroup.new
  end

  def create
    companies_groups_params[:company_id] = params[:companies_group][:company_id].reject!{|a| a== "" }
    @companies_group = CompaniesGroup.new(companies_groups_params)
    if @companies_group.save!
      flash[:notice] = "Group created successfully."
      redirect_to credit_suppliers_path(group: true)
    else
      flash[:alert] = "Something went wrong. Please try again"
      redirect_to new_companies_group_path(group: true)
    end
  end

  def edit
    @companies_group = CompaniesGroup.find(params[:id])
  end

  def update
    companies_groups_params[:company_id] = params[:companies_group][:company_id].reject!{|a| a== "" }
    @companies_group = CompaniesGroup.find(params[:id])
    if @companies_group.update_attributes(companies_groups_params)
      flash[:notice] = "Group created successfully."
      redirect_to credit_suppliers_path(group: true)
    else
      flash[:alert] = "Something went wrong. Please try again"
      redirect_to new_companies_group_path(group: true)
    end
  end

  def destroy
    companies_group = CompaniesGroup.find_by(id: params[:id])
    companies_group.destroy
    flash[:notice] = 'Group successfully destroyed.'
    redirect_to credit_suppliers_path(group: true)
  end

  def delete_group
    companies_groups = CompaniesGroup.where(id: params[:group_id]).first
    companies_groups.company_id = companies_groups.company_id.reject!{|a| a == params[:id] } unless companies_groups.nil?
    if companies_groups.company_id.count == 0
     companies_groups.destroy
     flash[:notice] = 'Group successfully destroyed.'
    else
     companies_groups.save!
     flash[:notice] = 'Customer successfully destroyed.'
    end
    redirect_to credit_suppliers_path(group: true)
  end

  private

    def companies_groups_params
      params.require(:companies_group).permit(:group_name, :seller_id, :company_id => [])
    end
end
