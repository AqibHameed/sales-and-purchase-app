module Api
  module V1
    class ProposalsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create, :negotiate]

      def create
        if current_company
          parcel = TradingParcel.where(id: params[:trading_parcel_id]).first
          if parcel.present?
            proposal = Proposal.new(proposal_params)
            proposal.buyer_id = current_company.id
            proposal.seller_id = parcel.company_id
            if proposal.save
              Message.create_new(proposal)
              render json: { success: true, message: 'Proposal Submitted Successfully' }
            else
              render json: { success: false, errors: proposal.errors.full_messages }
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
            get_proposal_details(proposal)
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
            if proposal.update_attributes(update_params)
              get_proposal_details(proposal)
              Message.create_new_negotiate(proposal, current_company)
              render :json => {:success => true, :message=> ' Proposal is negotiated successfully. ', :proposal => @data, response_code: 201 }
            else
              error = proposal.errors.full_messages.first
              render :json => {:success => false, :message=> '#{error}', response_code: 201 }
            end
          else
            render :json => {:success => false, :message=> 'Proposal does not exists for this id.', response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      private
      def proposal_params
        params.permit(:buyer_id, :seller_id, :credit, :price, :action_for, :trading_parcel_id, :notes)
      end

      def update_params
        params.permit(:price, :credit, :notes, :total_value, :percent)
      end

      def get_proposal_details(proposal)
        @data = {
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
          list_discount: proposal.trading_parcel.box_value,
          percent_offered: proposal.percent,
          avg_price_offered: proposal.price,
          total_price_offered: proposal.total_value,
          credit_offered: proposal.credit,
          comment: proposal.trading_parcel.comment,
          buyer_comment: proposal.buyer_comment,
          seller_comment: proposal.notes
        }
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