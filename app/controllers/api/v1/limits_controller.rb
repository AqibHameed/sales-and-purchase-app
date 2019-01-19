module Api
  module V1
    class LimitsController < ApiController
      before_action :current_customer
      skip_before_action :verify_authenticity_token, only: [:add_credit_limit, :add_market_limit, :add_overdue_limit, :block, :unblock, :credit_limit_list]
      protect_from_forgery with: :null_session
      include ActionView::Helpers::NumberHelper
      include ActionView::Helpers::TextHelper
      include ApplicationHelper

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/limits/add_limits
 @apiSampleRequest off
 @apiName add_limits
 @apiGroup Limits
 @apiDescription add limits
 @apiParamExample {json} Request-Example:
 {
  {
  "buyer_id": 1,
  "limit": 35000
  }
}
 @apiSuccessExample {json} SuccessResponse:
 [
  {
    "success": true,
    "message": "Limits updated."
  }
 ]
=end
      def add_limits

        if current_company
          buyer = Company.where(id: params[:buyer_id]).first
          if buyer.blank?
            render json: {success: false, message: "Buyer doesn't exist"}
          else
            buyer_limits = CreditLimit.find_by(buyer_id: params['buyer_id'], seller_id: current_company.id)
            buyer_limits = CreditLimit.new(seller_id: current_company.id, buyer_id: params['buyer_id']) if buyer_limits.nil?
            buyer_limits.credit_limit = params['limit'] unless params['limit'].blank?
            #buyer_limits.market_limit = params[:limit]['market_limit'] unless params[:limit]['market_limit'].blank?
            if buyer_limits.save
              render json: {success: true, message: 'Limits updated.'}
            else
              render json: {success: false, message: buyer_limits.errors.full_messages}
            end
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end
=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/limits/add_overdue_limit
 @apiSampleRequest off
 @apiName add_overdue_limit
 @apiGroup Limits
 @apiDescription add overdue limits
 @apiParamExample {json} Request-Example:
 {
  {
  "buyer_id": 1,
  "limit": 30
  }
}
 @apiSuccessExample {json} SuccessResponse:
 [
  {
    "success": true,
    "message": "Days Limit updated.",
    "value": "30 days"
  }
 ]
=end
      def add_overdue_limit
        if current_company
          buyer = Company.where(id: params[:buyer_id]).first
          if buyer.nil?
            render json: {success: false, message: "Buyer doesn't exist"}
          else
            dl = DaysLimit.where(buyer_id: params[:buyer_id], seller_id: current_company.id).first_or_initialize
            dl.days_limit = params[:limit]
            if dl.save
              render json: {success: true, message: 'Days Limit updated.', value: view_context.get_days_limit(buyer, current_company)}
            else
              render json: {success: false, message: dl.errors.full_messages}
            end
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/limits/block
 @apiSampleRequest off
 @apiName block
 @apiGroup Limits
 @apiDescription Block any company
 @apiParamExample {json} Request-Example:
{
	"company_id": 1
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true
}
=end

      def block
        if current_company
          unless params[:company_id].nil? || params[:company_id].blank?
            bu = BlockUser.where(block_company_ids: params[:company_id], company_id: current_company.id).first_or_initialize
            if bu.save
              render json: {success: true}
            else
              render json: {errors: bu.errors.full_messages, response_code: 201}
            end
          else
            render json: {errors: "Parameters missing", response_code: 201}
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/limits/unblock
 @apiSampleRequest off
 @apiName unblock
 @apiGroup Limits
 @apiDescription unBlock any company
 @apiParamExample {json} Request-Example:
{
	"company_id": 1
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true
}
=end

      def unblock
        if current_company
          b = BlockUser.where(block_company_ids: params[:company_id], company_id: current_company.id).first
          if b.nil?
            render json: {success: false, message: 'Company already unblocked or not found'}
          else
            b.destroy
            render json: {success: true}
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/limits/credit_limit_list?company_id=1&page=1&count=3
 @apiSampleRequest off
 @apiName credit limit list
 @apiGroup Limits
 @apiDescription buyer send or update proposal
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "limits": {
        "id": 1,
        "name": "Dummy co. 1",
        "total_limit": 0,
        "used_limit": 200,
        "available_limit": 0,
        "overdue_limit": "30 days",
        "supplier_connected": 3588,
        "reviewed": false
    },
    "response_code": 200
}
=end

      def credit_limit_list
        if current_company
          if params[:company_id].present?
            company = Company.find_by(id: params[:company_id])
            if company.nil?
              render json: {success: false, errors: "Company not found", response_code: 201}
            else
              review = Review.where(customer_id: current_customer.id, company_id: current_company.id)
              @data = {
                  id: company.id,
                  name: company.try(:name),
                  total_limit: get_credit_limit(company, current_company).round(2),
                  used_limit: get_used_credit_limit(company, current_company).round(2),
                  available_limit: get_available_credit_limit(company, current_company).round(2),
                  overdue_limit: get_days_limit(company, current_company),
                  #market_limit: get_market_limit_from_credit_limit_table(company, current_company).to_s,
                  supplier_connected: company.supplier_paid,
                  reviewed: review.present? ? true : false
              }
              render json: {success: true, limits: @data, response_code: 200}
            end
          else
            @data = []
            credit_limit = CreditLimit.where(seller_id: current_company.id)
            @array = []
            credit_limit.each do |c|
              if c.buyer.present?
                if c.credit_limit > 0
                  @array << c.buyer_id
                end
              end
            end
            days_limit = DaysLimit.where(seller_id: current_company.id)
            days_limit.each do |dl|
              if dl.buyer.present?
                if (dl.days_limit != 30) && dl.days_limit > 0
                  @array << dl.buyer_id
                end
              end
            end
            companies = Company.where("id in (?)", @array.uniq)
            companies.each do |c|
              review = Review.where(customer_id: current_customer.id, company_id: c.id)
              @data << {
                  id: c.id,
                  name: c.try(:name),
                  total_limit: get_credit_limit(c, current_company).round(2),
                  used_limit: get_used_credit_limit(c, current_company).round(2),
                  available_limit: get_available_credit_limit(c, current_company).round(2),
                  overdue_limit: get_days_limit(c, current_company),
                  #market_limit: get_market_limit_from_credit_limit_table(c, current_company).to_s,
                  supplier_connected: c.supplier_paid,
                  reviewed: review.present? ? true : false
              }
            end
            @companies = Kaminari.paginate_array(@data).page(params[:page]).per(params[:count])
            render json: {success: true, pagination: set_pagination(:companies), limits: @companies, response_code: 200}
          end
        else
          render json: {success: false, errors: "You have to login first!!", response_code: 201}
        end
      end

      def add_star
        stone = Stone.find_by(id: params[:stone_id])
        rating = Rating.new()
        rating.key = stone.description + '#' + (stone.weight.to_f).to_s
        rating.flag_type = 'Imp'
        rating.tender_id = params[:tender_id]
        rating.customer_id = current_company.id
        rating.save!
        render json: {success: true, response_code: 200}
      end
    end
  end
end
