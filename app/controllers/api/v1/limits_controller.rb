module Api
  module V1
    class LimitsController < ApiController
      before_action :current_customer
      skip_before_action :verify_authenticity_token, only: [:add_credit_limit, :add_market_limit, :add_overdue_limit, :block, :unblock, :credit_limit_list]

      include ActionView::Helpers::NumberHelper
      include ActionView::Helpers::TextHelper
      include ApplicationHelper

      def add_credit_limit
        if current_customer
          cl = CreditLimit.where(seller_id: current_customer.id, buyer_id: params[:buyer_id]).first_or_initialize
          total_clms = CreditLimit.where(seller_id: current_customer.id).sum(:credit_limit)
          total_limit = params[:limit].to_f
          cl.errors.add(:credit_limit, "should not be negative ") if total_limit < 0

          if current_customer.parent_id.present?
            sub_company_limit = SubCompanyCreditLimit.find_by(sub_company_id: current_customer.id)
            if sub_company_limit.try(:credit_type) == "General"
              limit = sub_company_limit.credit_limit
            elsif sub_company_limit.try(:credit_type) == "Specific"
              limit = cl.credit_limit
              unless limit.present?
                cl.errors.add(:credit_limit, "not set by parent company")
              end
            else
              cl.errors.add(:credit_limit, "not set by parent company")
            end
            if limit.to_f < (total_limit.to_f + total_clms.to_f)
              cl.errors.add(:credit_limit, "can't be greater than assigned limit")
            else
              cl.credit_limit  = total_limit.to_f
            end
          else
            cl.credit_limit  = total_limit.to_f
          end
          if cl.errors.any?
            render json: { success: false, errors: cl.errors.full_messages.first }
          else
            if cl.save
              render json: { success: true, message: 'Credit Limit updated.', limit: cl.credit_limit }
            else
              render json: { success: false, message: cl.errors.full_messages.first }
            end
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def add_market_limit
        if current_customer
          buyer = Customer.where(id: params[:buyer_id]).first
          if buyer.nil?
            render json: { success: false, message: "Buyer doesn't exist" }
          else
            cl = CreditLimit.where(buyer_id: params[:buyer_id], seller_id: current_customer.id).first_or_initialize
            cl.market_limit = params[:limit]
            if cl.save
              render json: { success: true, message: 'Market Limit updated.', value: cl.market_limit }
            else
              render json: { success: false, message: cl.errors.full_messages }
            end
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def add_overdue_limit
        if current_customer
          buyer = Customer.where(id: params[:buyer_id]).first
          if buyer.nil?
            render json: { success: false, message: "Buyer doesn't exist" }
          else
            dl = DaysLimit.where(buyer_id: params[:buyer_id], seller_id: current_customer.id).first_or_initialize
            dl.days_limit = params[:limit]
            if dl.save
              render json: { success: true, message: 'Days Limit updated.', value: view_context.get_days_limit(buyer, current_customer) }
            else
              render json: { success: false, message: dl.errors.full_messages }
            end
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def block
        if current_customer
          unless params[:customer_id].nil? || params[:customer_id].blank?
            BlockUser.where(block_user_ids: params[:customer_id], customer_id: current_customer.id).first_or_create
            render json: { success: true }
          else
            render json: { errors: "Parameters missing", response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def unblock
        if current_customer
          b = BlockUser.where(block_user_ids: params[:customer_id], customer_id: current_customer.id).first
          if b.nil?
            render json: { success: false, message: 'Customer already unblocked or not found' }
          else
            b.destroy
            render json: { success: true }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def credit_limit_list
        if current_customer
          if params[:customer_id].present?
            customer = Customer.where(id: params[:customer_id]).first
            if customer.nil?
             render json: { success: false, errors: "Customer not found", response_code: 201 }
            else
              @data = {
                id: customer.id.to_s,
                company: customer.company.try(:name),
                total_limit: get_credit_limit(customer, current_customer),
                used_limit: get_used_credit_limit(customer, current_customer),
                available_limit: get_available_credit_limit(customer, current_customer),
                overdue_limit: get_days_limit(customer, current_customer),
                market_limit: get_market_limit_from_credit_limit_table(customer, current_customer).to_s,
                supplier_connected: supplier_connected(customer, current_customer).to_s
              }
              render json: { success: true, limits: @data, response_code: 200  }
            end
          else
            @data = []
            credit_limit = CreditLimit.where(seller_id: current_customer.id)
            credit_limit.each do |c|
              if c.buyer.present?
                group = CompaniesGroup.where('customer_id LIKE ?', "%#{c.buyer.id}%").first
                unless group.present?
                  @data << {
                  id: c.buyer.id.to_s,
                  company: c.buyer.try(:company).try(:name),
                  total_limit: get_credit_limit(c.buyer, current_customer),
                  used_limit: get_used_credit_limit(c.buyer, current_customer),
                  available_limit: get_available_credit_limit(c.buyer, current_customer),
                  overdue_limit: get_days_limit(c.buyer, current_customer),
                  market_limit: get_market_limit_from_credit_limit_table(c.buyer,current_customer).to_s,
                  supplier_connected: supplier_connected(c.buyer,current_customer).to_s }
                end
              end
            end
            render json: { success: true, limits: @data, response_code: 200  }
          end
        else
          render json: { success: false, errors: "You have to login first!!", response_code: 201 }
        end
      end

      def add_star
       stone = Stone.find_by(id: params[:stone_id])
       rating = Rating.new()
       rating.key = stone.description+'#'+(stone.weight.to_f).to_s
       rating.flag_type = 'Imp'
       rating.tender_id = params[:tender_id]
       rating.customer_id = current_customer.id
       rating.save!
       render json: { success: true, response_code: 200  }
      end
    end
  end
end