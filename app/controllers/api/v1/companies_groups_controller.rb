module Api
  module V1
    class CompaniesGroupsController < ApiController
      before_action :current_customer
      skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

      def index
        if current_company
          @companies_group = CompaniesGroup.where(seller_id: current_company.id)
          render json: { success: true, groups: group_data(@companies_group)}
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def create
        if current_company
          companies_group = CompaniesGroup.new
          companies_group.group_name = params[:group_name]
          companies_group.company_id = params[:company_id]
          companies_group.group_overdue_limit = params[:group_overdue_limit]
          companies_group.seller_id = current_company.id
          if companies_group.save
            CompaniesGroup.remove_credit_limits(params[:company_id], current_company)
            render json: { success: true, message: 'Group created successfully', data: { id: companies_group.id.to_s, group_name: companies_group.group_name, companies: group_data(companies_group)}, response_code: 200 }
          else
            render json: { success: false, errors: companies_group.errors.full_messages, response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def update
        companies_group = CompaniesGroup.find(params[:id])
        if current_company && current_company.id == companies_group.seller_id
          companies_group.group_name = params[:group_name]
          companies_group.company_id = params[:company_id]
          companies_group.group_overdue_limit = params[:group_overdue_limit]
          if companies_group.save
            CompaniesGroup.remove_credit_limits(params[:company_id], current_company)
            render json: { success: true, message: 'Group updated successfully', data: { id: companies_group.id.to_s, group_name: companies_group.group_name, companies: group_data(companies_group)}, response_code: 200 }
          else
            render json: { success: false, errors: companies_group.errors.full_messages, response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def destroy
        companies_group = CompaniesGroup.find(params[:id])
        if current_company && current_company.id == companies_group.seller_id
          companies_group.destroy if companies_group
          render json: { success: true, response_code: 200 }
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def group_data(companies_group)
        @data = []
        count = companies_group.count rescue 0
        unless count == 0
          companies_group.each do |group|
            list = []
            group.company_id.each do |c|
              company = get_company(c)
              list << {
                id: company.id.to_s,
                name: company.name,
                total_limit: get_credit_limit(company, current_company),
                used_limit: get_used_credit_limit(company, current_company),
                available_limit: get_available_credit_limit(company, current_company),
                overdue_limit: get_days_limit(company, current_company),
                supplier_connected: supplier_connected(company, current_company).to_s
              }
            end
            @data << {
              id: group.id.to_s,
              group_name: group.group_name,
              group_market_limit: group.group_market_limit,
              group_overdue_limit: group.group_overdue_limit,
              companies: list
            }
          end
        else
          unless companies_group.blank?
            companies_group.company_id.each do |c|
              company = get_company(c)
              @data << {
                id: company.id.to_s,
                name: company.name,
                total_limit: get_credit_limit(company, current_company),
                used_limit: get_used_credit_limit(company, current_company),
                available_limit: get_available_credit_limit(company, current_company),
                overdue_limit: get_days_limit(company, current_company),
                #market_limit: get_market_limit_from_credit_limit_table(company, current_company).to_s,
                supplier_connected: supplier_connected(company, current_company).to_s
              }
            end
          end
        end
        @data
      end
    end
  end
end