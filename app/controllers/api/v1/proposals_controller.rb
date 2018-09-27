module Api
  module V1
    class ProposalsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create, :negotiate]
      before_action :set_proposal, only: [ :negotiate, :show, :accept_and_decline ]
      before_action :verify_current_company, only: [ :negotiate, :show, :create, :accept_and_decline ]

      def create
        if current_company
          parcel = TradingParcel.where(id: params[:trading_parcel_id]).first      
            if parcel.present?
              credit_limit = CreditLimit.where(seller_id: parcel.try(:company_id), buyer_id: current_company.id).first
              # if current_company.is_overdue || (credit_limit.present? && credit_limit.market_limit.to_f < parcel.total_value)
              if check_for_group_overdue_limit(current_company, parcel.company) || check_for_group_market_limit(current_company, parcel.company)
                render json: { success: false, message: 'Please, Clear your overdue payments to send proposal.'}
              elsif current_company.is_blocked_by_supplier(parcel.try(:company_id))
                render json: { success: false, message: 'You are blocked by supplier, So please contact to supplier.'}
              elsif current_company.check_group_overdue(parcel.try(:company_id))
                render json: { success: false, message: 'You cannot buy anything. Your group customer have overdue.'}
              elsif current_company.is_overdue || current_company.check_market_limit_overdue(get_market_limit(current_company, parcel.try(:company_id)), parcel.try(:company_id))
                render json: { success: false, message: 'You are blocked from purchasing from this seller due to number of days late on a payment or amount payable to the market.' }
              else
                proposal = Proposal.new(proposal_params)
                proposal.buyer_id = current_company.id
                proposal.seller_id = parcel.company_id
                proposal.notes = parcel.comment
                proposal.action_for = parcel.company_id
                proposal.buyer_comment = params[:comment]
                if proposal.save
                  
                  proposal.negotiations.create(price: proposal_params[:price], credit: proposal_params[:credit], total_value: proposal_params[:total_value], percent: proposal_params[:percent], comment: parcel.comment, from: 'buyer')

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
        get_proposal_details(@proposal)
        render :json => {:success => true, :proposal=> @data, response_code: 200 }
      end

      def accept_and_decline
        if params[:perform] == 'accept'
          accpet_proposal(@proposal)
          if @available_credit_limit < @total_price
            render :json => {:success => true, :message=> " Your credit_limit is increased form  #{@available_credit_limit}   to   #{@new_limit}", response_code: 201 }
          else
            render :json => {:success => true, :message=> ' Proposal is accepted. ', response_code: 201 }
          end
        elsif params[:perform] == 'reject'
          @proposal.status = 2
          if @proposal.save(validate: false)
            render :json => {:success => true, :message=> ' Proposal is rejected. ', response_code: 201 }
          else
            render :json => {:success => false, :message=> ' Something went wrong. ', response_code: 201 }
          end
        else
          render :json => {:success => false, :message=> ' Appropriate action should be present. ', response_code: 201 }
        end      
      end

      def negotiate
        if params[:negotiation_id].present?
          negotiation = Negotiation.where(id: params[:negotiation_id]).first
          render :json => {:success => false, :message=> 'Negotiation does not exists for the negotiation id.', response_code: 201 } and return unless negotiation
          render :json => {:success => false, :message=> 'This negotiation is not yours.', response_code: 201 } and return unless negotiation.whose == current_company
          if negotiation.update_attributes(negotiation_params)
            render :json => {:success => true, :message=> ' Negotiation is updated successfully. ', :negotiation => negotiation, response_code: 200 }  
          else
            render :json => {:success => false, :message=> 'Negotiation is not updated successfully..', response_code: 201 }
          end
        else
          if @proposal.negotiations.create((current_company == @proposal.buyer) ? negotiation_params.merge({from: 'buyer'}) : negotiation_params.merge({from: 'seller'}))
            # proposal.update_attributes(negotiated: true)
            receiver =  (current_company == @proposal.buyer) ? @proposal.seller : @proposal.buyer
            receiver_emails = receiver.customers.map{ |c| c.email }
            CustomerMailer.send_negotiation(@proposal, receiver_emails, current_customer.email).deliver
            get_proposal_details(@proposal)
            # Message.create_new_negotiate(proposal, current_company)
            render :json => {:success => true, :message=> ' Proposal is negotiated successfully. ', :proposal => @data, response_code: 200 }  
          else
            render :json => {:success => false, :message=> 'Proposal is not negotiated successfully..', response_code: 201 }
          end
        end        
      end

      private

      def set_proposal
        @proposal = Proposal.where(id: params[:id]).first
        render :json => {:success => false, :message=> 'Proposal does not exists for this id.', response_code: 201 } and return unless @proposal
      end

      def proposal_params
        params.permit(:buyer_id, :seller_id, :credit, :price, :percent, :total_value, :trading_parcel_id)
      end

      def update_params
        params.permit(:price, :credit, :total_value, :percent)
      end

      def negotiation_params
        params.permit(:price, :credit, :total_value, :percent, :comment)
      end

      def verify_current_company
        render json: { errors: "Not authenticated", response_code: 201 } and return unless current_company
      end

      def get_proposal_details(proposal)        
        last_negotiation = proposal.negotiations.order('created_at ASC' ).last
        if proposal.status == 'negotiated' 
          if proposal.negotiations.present?
            status = "negotiated"
          else
            status = nil
          end
        else 
          status = proposal.status
        end
        @data = {
          status: status,
          supplier_name: proposal.seller.name,
          source: proposal.trading_parcel.present? ?  proposal.trading_parcel.source : 'N/A',
          description: proposal.trading_parcel.present? ? proposal.trading_parcel.description : 'N/A',
          sight: proposal.trading_parcel.present? ? proposal.trading_parcel.sight : 'N/A',
          no_of_stones: proposal.trading_parcel.present? ? proposal.trading_parcel.no_of_stones : 'N/A',
          carats: proposal.trading_parcel.present? ? proposal.trading_parcel.weight: 'N/A',
          cost: proposal.trading_parcel.present? ? proposal.trading_parcel.cost.to_f : 'N/A',
          list_percentage: proposal.trading_parcel.present? ? proposal.trading_parcel.percent.to_f : 'N/A',
          list_avg_price: proposal.trading_parcel.present? ? proposal.trading_parcel.price.to_f : 'N/A',
          list_total_price: proposal.trading_parcel.present? ? proposal.trading_parcel.total_value.to_f : 'N/A',
          list_credit: proposal.trading_parcel.present? ? proposal.trading_parcel.credit_period : 'N/A',
          list_discount: proposal.trading_parcel.present? ? proposal.trading_parcel.box_value.to_i : 'N/A',
          list_comment: proposal.trading_parcel.present? ? proposal.trading_parcel.comment : 'N/A'
        }
        if proposal.negotiations.present? && proposal.status == 'negotiated'
          negotiated = {
            id: last_negotiation.try(:id),
            offered_percentage: last_negotiation.try(:percent).to_f,
            offered_price: last_negotiation.try(:price).to_f,
            offered_total_value: last_negotiation.try(:total_value).to_f,
            offered_credit: last_negotiation.try(:credit),
            offered_comment: last_negotiation.try(:comment),
            offered_from: last_negotiation.try(:from)
          }
          negotiations = []
          proposal.negotiations.each do |negotiation|
            negotiations << {
              id: negotiation.id,
              offered_percent: negotiation.percent.to_f,
              offered_credit: negotiation.credit,
              offered_price: negotiation.price.to_f,
              offered_total_value: negotiation.total_value.to_f,
              offered_comment: negotiation.comment,
              offered_from: negotiation.from,
              is_mine: negotiation.whose == current_company
            }
          end
          @data.merge!(negotiated: negotiated)
          @data.merge!(total_negotiations: proposal.negotiations.count)
          @data.merge!(negotiations: negotiations)      
        else
          @data.merge!(negotiated: nil)
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