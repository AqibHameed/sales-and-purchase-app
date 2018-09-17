module Api
  module V1
    class ProposalsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create, :negotiate]

      def create
        if current_company
          parcel = TradingParcel.where(id: params[:trading_parcel_id]).first      
            if parcel.present?
              # if current_company.is_blocked_by_supplier(parcel.try(:company_id))
              credit_limit = CreditLimit.where(seller_id: parcel.try(:company_id), buyer_id: current_company.id).first
              if current_company.is_overdue || (credit_limit.present? && credit_limit.market_limit.to_f < parcel.total_value)
                render json: { success: false, message: 'You are blocked from purchasing from this seller due to number of days late on a payment or amount payable to the market.' }
              else
                proposal = Proposal.new(proposal_params)
                proposal.buyer_id = current_company.id
                proposal.seller_id = parcel.company_id
                proposal.notes = parcel.comment
                proposal.action_for = parcel.company_id
                proposal.buyer_comment = params[:comment]
                if proposal.save
                  Message.create_new(proposal)
                  render json: { success: true, message: 'Proposal Submitted Successfully' }
                else
                  render json: { success: false, errors: proposal.errors.full_messages }
                end
              end
            else
              render json: { success: false, message: 'Parcel does not exists for this id.' }
            end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def show
        if current_company
          proposal = Proposal.where(id: params[:id]).first
          if proposal.present?
            if proposal.action_for == proposal.buyer_id
              company = Company.where(id: proposal.seller_id).first
            else
              company = Company.where(id: proposal.buyer_id).first
            end
            get_proposal_details(proposal, company.name)
            render :json => {:success => true, :proposal=> @data, response_code: 200 }
          else
            render :json => {:success => false, :message=> 'Proposal does not exists for this id.', response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def accept_and_decline
        if current_company
          proposal = Proposal.where(id: params[:id]).first
          if params[:perform] == 'accept'
            accpet_proposal(proposal)
            if @available_credit_limit < @total_price
              render :json => {:success => true, :message=> " Your credit_limit is increased form  #{@available_credit_limit}   to   #{@new_limit}", response_code: 201 }
            else
              render :json => {:success => true, :message=> ' Proposal is accepted. ', response_code: 201 }
            end
          elsif params[:perform] == 'reject'
            proposal.status = 2
            if proposal.save(validate: false)
              render :json => {:success => true, :message=> ' Proposal is rejected. ', response_code: 201 }
            else
              render :json => {:success => false, :message=> ' Something went wrong. ', response_code: 201 }
            end
          else
            render :json => {:success => false, :message=> ' Appropriate action should be present. ', response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def negotiate
        if current_company
          proposal = Proposal.where(id: params[:id]).first
          if proposal.present?
            if current_company.id == proposal.buyer_id
              sender_name = proposal.buyer.name
              proposal.update_attributes(update_params)
              proposal.buyer_price = params[:price]
              proposal.buyer_credit = params[:credit]
              proposal.buyer_total_value = params[:total_value]
              proposal.buyer_percent = params[:percent]
              proposal.buyer_comment = params[:comment]
              proposal.action_for = proposal.seller_id
              proposal.save
            else
              sender_name = proposal.seller.name
              proposal.update_attributes(update_params)
              proposal.seller_price = params[:price]
              proposal.seller_credit = params[:credit]
              proposal.seller_total_value = params[:total_value]
              proposal.seller_percent = params[:percent]
              proposal.notes = params[:comment]
              proposal.action_for = proposal.buyer_id
              proposal.save
            end
            proposal.negotiated = true
            proposal.save
            get_proposal_details(proposal,sender_name)
            Message.create_new_negotiate(proposal, current_company)
            render :json => {:success => true, :message=> ' Proposal is negotiated successfully. ', :proposal => @data, response_code: 201 }
          else
            render :json => {:success => false, :message=> 'Proposal does not exists for this id.', response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      private
      def proposal_params
        params.permit(:buyer_id, :seller_id, :credit, :price, :percent, :total_value, :trading_parcel_id)
      end

      def update_params
        params.permit(:price, :credit, :total_value, :percent)
      end

      def get_proposal_details(proposal,sender_name)
        if proposal.status == 'accepted'
          status = 'accepted'
        elsif proposal.status == 'rejected'
          status = 'rejected'
        else
          status = nil
        end
        buyer_offers = {
          percent: proposal.buyer_percent,
          avg_price: proposal.buyer_price,
          total_price: proposal.buyer_total_value,
          credit: proposal.buyer_credit,
          negotiated_comment: proposal.buyer_comment
        }
        seller_offers= {
          percent: proposal.seller_percent,
          avg_price: proposal.seller_price,
          total_price: proposal.seller_total_value,
          credit: proposal.seller_credit,
          negotiated_comment: proposal.notes
        }
        @data = {
          status: status,
          sender_name: sender_name,
          supplier_name: proposal.seller.name,
          source: proposal.trading_parcel.source,
          description: proposal.trading_parcel.description,
          sight: proposal.trading_parcel.sight,
          no_of_stones: proposal.trading_parcel.no_of_stones,
          carats: proposal.trading_parcel.weight,
          cost: proposal.trading_parcel.cost,
          list_percentage: proposal.trading_parcel.percent,
          list_avg_price: proposal.trading_parcel.price,
          list_total_price: proposal.trading_parcel.total_value,
          list_credit: proposal.trading_parcel.credit_period,
          list_discount: proposal.trading_parcel.box_value.to_i,
          list_comment: proposal.trading_parcel.comment
        }
        if proposal.negotiated == true
          if current_company.id == proposal.seller_id
            buyer_last_negotiated = {
              offered_percentage: proposal.buyer_percent,
              offered_price: proposal.buyer_price,
              offered_total_value: proposal.buyer_total_value,
              offered_credit: proposal.buyer_credit,
              offered_comment: proposal.buyer_comment
            }
            @data.merge!(buyer_last_negotiated)
            @data.merge!(negotiated: seller_offers)
          else current_company.id == proposal.buyer_id
            seller_last_negotiated = {
              offered_percentage: proposal.seller_percent,
              offered_price: proposal.seller_price,
              offered_total_value: proposal.seller_total_value,
              offered_credit: proposal.seller_credit,
              offered_comment: proposal.notes
            }
            @data.merge!(seller_last_negotiated)
            @data.merge!(negotiated: buyer_offers)
          end
        else
          offered = {
          offered_percentage: proposal.percent,
          offered_price: proposal.price,
          offered_total_value: proposal.total_value,
          offered_credit: proposal.credit,
          offered_comment: proposal.buyer_comment,
          negotiated: nil
          }
          @data.merge!(offered)
        end
      end

      def accpet_proposal(proposal)
        @proposal = proposal
        ActiveRecord::Base.transaction do
          @proposal.status = 1
          if @proposal.save(validate: false)
            @available_credit_limit = get_available_credit_limit(@proposal.buyer, current_company).to_f
            @total_price = @proposal.price*@proposal.trading_parcel.weight
            if @available_credit_limit < @total_price
              credit_limit = CreditLimit.where(buyer_id: @proposal.buyer_id, seller_id: current_company.id).first
              if credit_limit.nil?
                CreditLimit.create(buyer_id: @proposal.buyer_id, seller_id: current_company.id, credit_limit: @total_price)
              else
                @new_limit = credit_limit.credit_limit + (@total_price - @available_credit_limit)
                credit_limit.update_attributes(credit_limit: @new_limit)
              end
            end
            @proposal.trading_parcel.update_column(:sold, true)
            Transaction.create_new(@proposal)
          end
        end
      end

    end
  end
end