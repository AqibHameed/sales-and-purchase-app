module Api
  module V1
    class CompaniesGroupsController < ApiController
      before_action :current_customer
      skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

      include ActionView::Helpers::NumberHelper
      include ActionView::Helpers::TextHelper
      include ApplicationHelper

      def index
        if current_customer
          @companies_group = CompaniesGroup.where(seller_id: current_customer.id)
          render json: { success: true, groups: group_data(@companies_group)}
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end
      
      def create
        if current_customer
          companies_group = CompaniesGroup.new
          companies_group.group_name = params[:group_name]
          companies_group.customer_id = params[:customer_id]
          companies_group.seller_id = current_customer.id
          if companies_group.save
            render json: { success: true, message: 'Group created successfully', data: { id: companies_group.id, group_name: companies_group.group_name, customers: group_data(companies_group)}, response_code: 200 }
          else
            render json: { success: false, errors: companies_group.errors.full_messages, response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def update
        companies_group = CompaniesGroup.find(params[:id])
        if current_customer && current_customer.id == companies_group.seller_id
          companies_group.group_name = params[:group_name]
          companies_group.customer_id = params[:customer_id]
          if companies_group.save
            render json: { success: true, message: 'Group updated successfully', data: { id: companies_group.id, group_name: companies_group.group_name, customers: group_data(companies_group)}, response_code: 200 }
          else
            render json: { success: false, errors: companies_group.errors.full_messages, response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def destroy
        companies_group = CompaniesGroup.find(params[:id])
        if current_customer && current_customer.id == companies_group.seller_id
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
            group.customer_id.each do |c|
              customer = get_customer(c)
              list << {
                id: customer.id.to_s,
                customer_name: customer.name,
                company: customer.company.try(:name),
                total_limit: get_credit_limit(customer, current_customer), 
                used_limit: get_used_credit_limit(customer, current_customer), 
                available_limit: get_available_credit_limit(customer, current_customer), 
                overdue_limit: get_days_limit(customer, current_customer), 
                market_limit: get_market_limit_from_credit_limit_table(customer, current_customer).to_s, 
                supplier_connected: supplier_connected(customer, current_customer).to_s
              }
            end
            @data << { id: group.id, group_name: group.group_name, customers: list }
          end
        else
          unless companies_group.blank?
            companies_group.customer_id.each do |c|
              customer = get_customer(c)
              @data << {
                id: customer.id.to_s,
                customer_name: customer.name,
                company: customer.company.try(:name),
                total_limit: get_credit_limit(customer, current_customer), 
                used_limit: get_used_credit_limit(customer, current_customer), 
                available_limit: get_available_credit_limit(customer, current_customer), 
                overdue_limit: get_days_limit(customer, current_customer), 
                market_limit: get_market_limit_from_credit_limit_table(customer, current_customer).to_s, 
                supplier_connected: supplier_connected(customer, current_customer).to_s
              }
            end
          end
        end
        @data
      end
    end
  end
end