module Api
  module V1
    class LimitsController < ApiController
      before_action :current_customer
      skip_before_action :verify_authenticity_token, only: [:add_credit_limit, :add_market_limit, :add_overdue_limit]

      def add_credit_limit
        if current_customer
          cl = CreditLimit.where(supplier_id: current_customer.id, buyer_id: params[:buyer_id]).first_or_initialize
          total_clms = CreditLimit.where(supplier_id: current_customer.id).sum(:credit_limit)
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
            cl = CreditLimit.where(buyer_id: params[:buyer_id], supplier_id: current_customer.id).first_or_initialize
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
            dl = DaysLimit.where(buyer_id: params[:buyer_id], supplier_id: current_customer.id).first_or_initialize
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
    end
  end
end