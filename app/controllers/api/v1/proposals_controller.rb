module Api
  module V1
    class ProposalsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create]

      def create
        if current_company
          parcel = TradingParcel.where(params[:trading_parcel_id]).first
          proposal = Proposal.new(proposal_params)
          proposal.buyer_id = parcel.company_id
          proposal.seller_id = current_company.id
          if proposal.save
            Message.create_new(proposal)
            render json: { success: true, message: 'Proposal Submitted Successfully' }
          else
            render json: { success: false, errors: proposal.errors.full_messages }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      private
      def proposal_params
        params.permit(:buyer_id, :seller_id, :credit, :price, :action_for, :trading_parcel_id, :notes)
      end
    end
  end
end