module Api
  module V1
    class MessagesController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create]
      before_action :current_customer, only: [:index, :show, :create]

      def index
        if current_company
          from_ids = Company.where('name LIKE ?', "%#{params[:search]}%").ids
          all_messages = Message.where(receiver_id: current_company.id, sender_id: from_ids)
          @messages = all_messages.page(params[:page]).per(params[:count])
          render json: { pagination: set_pagination(:messages), messages: messages_data(@messages), response_code: 200 }
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def show
        if current_company
          if params[:id].present?
            message  = Message.where(id: params[:id]).first
            if message.present?
              sender = Company.where(id: message.sender_id).first
              receiver = Company.where(id: message.receiver_id).first
              @message = {
                id: message.id,
                sender: sender.name,
                receiver: receiver.name,
                message: message.message,
                message_type: message.message_type,
                subject: message.subject,
                created_at: message.created_at,
                updated_at: message.updated_at
              }
              render :json => {:success => true, :message => @message, response_code: 200 }
            else
              render :json => {:success => false, :message => 'Message does not exists for this id.', response_code: 200 }
            end
          else
            render :json => {:success => false, :message => 'Message id should be present', response_code: 200 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def create
        if current_company
          @message = Message.new(message_params)
          @message.sender_id = current_company.id
          if @message.save
            render json: { success: true, message: 'Message Created Successfully' }
          else
            render json: { success: false, message: 'Invalid Parameters' }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      private

      def message_params
        params.require(:message).permit(:subject, :message, :message_type, :receiver_id)
      end

      def messages_data(messages)
        @data = []
        messages.each do |message|
          if message.proposal.present?
            if message.proposal.status == 'accepted'
              status = 'accepted'
            elsif message.proposal.status == 'rejected'
              status = 'rejected'
            elsif message.proposal.negotiated == true
              status = 'negotiated'
            else
              status = nil
            end
          else
            status = nil
          end
          data = {
            id: message.id,
            proposal_id: message.proposal_id,
            sender: message.sender.name,
            receiver: current_company.name,
            message: message.message,
            message_type: message.message_type,
            subject: message.subject,
            created_at: message.created_at,
            updated_at: message.updated_at,
            date: message.created_at,
            description: message.proposal.present? ? (message.proposal.trading_parcel.present? ? message.proposal.trading_parcel.description : 'N/A') : 'N/A',
            status: status
          }
          if message.proposal.present? && message.proposal.trading_parcel.present? 
            offered_price = message.proposal.price.to_f
            offered_percent = ((offered_price.to_f/message.proposal.trading_parcel.price.to_f)-1).to_f*100
            data.merge!(calculation: offered_percent.to_i)
          end
          @data << data
        end
        @data
      end
    end
  end
end
