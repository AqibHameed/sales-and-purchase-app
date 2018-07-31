module Api
  module V1
    class MessagesController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create]

      def index
       @messages = []
       @all_messages = Message.where(receiver_id: current_company.id)
       @all_messages.each do |message|
          sender = Company.where(id: message.sender_id).first
          @data = {
            id: message.id,
            sender: sender.name,
            receiver: current_company.name,
            message: message.message,
            message_type: message.message_type,
            subject: message.subject,
            created_at: message.created_at,
            updated_at: message.updated_at
          }
          @messages << @data
       end
       render :json => {:success => true, :messages=> @messages, response_code: 200 }
      end

      def show
        if params[:id].present?
         message  = Message.find(params[:id])
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
          render :json => {:success => false, :message => 'This message does not exist', response_code: 200 }
        end
      end

      def create
        @message = Message.new(message_params)
        @message.sender_id = current_company.id
        if @message.save
          render json: { success: true, message: 'Message Created Successfully' }
        else
          render json: { success: false, message: 'Invalid Parameters' }
        end
      end

      private

      def message_params
        params.require(:message).permit(:subject, :message, :message_type, :receiver_id)
      end
    end
  end
end
