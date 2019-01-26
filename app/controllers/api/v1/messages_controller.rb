module Api
  module V1
    class MessagesController < ApiController
      include MessagesHelper
      include CustomersHelper
      skip_before_action :verify_authenticity_token, only: [:create]
      before_action :current_customer, only: [:index, :show, :create]

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/messages
 @apiSampleRequest off
 @apiName index
 @apiGroup Messages
 @apiDescription Get all messages of authorized user
 @apiSuccessExample {json} SuccessResponse:
{
    "pagination": {
        "total_pages": 1,
        "prev_page": null,
        "next_page": null,
        "current_page": 1
    },
    "messages": [
        {
            "id": 2,
            "proposal_id": 2,
            "sender": "SafeTrade",
            "receiver": "OnGraph",
            "message": " </br>For more Details about proposal, <a href=\"/proposals/2\">Click Here</a>",
            "message_type": "Proposal",
            "subject": "Seller sent a new proposal.",
            "created_at": "2018-10-25T12:44:44.000Z",
            "updated_at": "2018-10-25T12:44:44.000Z",
            "date": "2018-10-25T12:44:44.000Z",
            "description": "+100 CT",
            "status": "accepted",
            "calculation": -9.09
        },
        {
            "request_id": 9,
            "sender": "Seller A",
            "message": "You have a new live monitoring request from seller"
        }
    ],
    "response_code": 200
}

=end

      def index
        all_messages = []
        payment_messages = []
        live_monitor_request_messages = []
        if current_company
          messages = Message.customer_messages(current_company.id).group_by(&:proposal_id)
          messages.each do |proposal_id, messages|
            all_messages << messages.last
          end
          security_requests = Message.customer_secuirty_data_messages(current_company.id).group_by(&:premission_request_id)
          security_requests.each do |message|
            live_monitor_request_messages << message.last
          end

          payment_message = Message.customer_payment_messages(current_company.id).group_by(&:partial_payment_id)
          payment_message.each do |transaction_id, messages|
            payment_messages << messages.last
          end
          @messages = Kaminari.paginate_array(messages_data(all_messages, payment_messages, params[:status], params[:description], params[:company], live_monitor_request_messages)).page(params[:page]).per(params[:count])
          render json: { pagination: set_pagination(:messages), messages: @messages, response_code: 200 }
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def limit_messages
        if current_company
          all_messages = Message.where("receiver_id = ? && message_type in (?) ", current_company.id, ['Limit Increase Request' , 'Limit Increase Accept', 'Limit Increase Reject'])
          @messages = all_messages.page(params[:page]).per(params[:count])
          render json: { pagination: set_pagination(:messages), messages: messages_data_for_limit_messages(@messages), response_code: 200 }
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def unread_count
        if current_company
          all_messages = []
          messages = Message.customer_messages(current_company.id).group_by(&:proposal_id)
          messages.each do |proposal_id, messages|
            all_messages << messages.last
          end
          data = {count: new_messages(all_messages).count}
          render json: {success: true, inbox: data, response_code: 200}
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end
=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/messages/2
 @apiSampleRequest off
 @apiName show
 @apiGroup Messages
 @apiDescription show single message with message_id = 2
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": {
        "id": 2,
        "sender": "SafeTrade",
        "receiver": "OnGraph",
        "message": " </br>For more Details about proposal, <a href=\"/proposals/2\">Click Here</a>",
        "message_type": "Proposal",
        "subject": "Seller sent a new proposal.",
        "created_at": "2018-10-25T12:44:44.000Z",
        "updated_at": "2018-10-25T12:44:44.000Z"
    },
    "response_code": 200
}
=end
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

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/messages
 @apiSampleRequest off
 @apiName CREATE
 @apiGroup Messages
 @apiDescription create message
 @apiParamExample {json} Request-Example:
 {"message":{
	"subect": "Proposal send",
	"message": "this is contant",
	"message_type": "simple",
	"receiver_id": "3"
}
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": "Message Created Successfully"
}
=end

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

      def messages_data(messages, payment_messages, status, description, company, live_monitor_request_messages)
        @data = []
        @messages = messages
        if status.present?
          if status == 'negotiated'
            @messages = negotiation_messages(messages)
          elsif status == 'new'
            @messages = new_messages_payment(messages, payment_messages, live_monitor_request_messages)
          else  
            @messages = @messages.map{ |m| m if m.proposal && m.proposal.status == status }.compact
          end
        end
        if description.present?
          @messages = @messages.map{ |m| m if m.proposal.present? && m.proposal.trading_parcel.present? && m.proposal.trading_parcel.description == description }.compact
        end
        if company.present?
          c = Company.where(name: company).first
          @messages = @messages.map{ |m| m if m.sender.present? && m.sender == c}.compact
        end
        @messages.each do |message|
          if (message.proposal.present? && message.proposal.trading_parcel.present?) || (message.partial_payment.present?)
            if message.partial_payment.present?
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
                  status: 'new'
              }
            else
                if message.proposal.status == 'accepted'
                  status = 'accepted'
                elsif message.proposal.status == 'rejected'
                  status = 'rejected'
                elsif message.proposal.negotiations.present?
                  who =  (current_company == message.proposal.buyer) ? 'buyer' : 'seller'
                  last_self_negotiation = message.proposal.negotiations.last
                  if last_self_negotiation.present? && last_self_negotiation.from == who
                    status = 'negotiated'
                  else
                    status = 'new'
                  end
                else
                  status = 'new'
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
                  data.merge!(calculation: offered_percent.round(2))
                end
            end
          else
            unless message.premission_request.blank?
              if message.premission_request.status == 'pending'
                data ={
                    request_id: message.premission_request.id,
                    sender: message.premission_request.sender.name,
                    message: message.subject,
                    status: message.premission_request.status
                }
              end
            end
          end
          @data << data
        end
        @data
      end
      def messages_data_for_limit_messages(messages)
        @data = []
        messages.each do |message|
          if message.proposal.present? && message.proposal.trading_parcel.present?
          else
            parcel = TradingParcel.where(id: message.proposal_id).first
            data = {
              id: message.id,
              parcel_id: message.proposal_id,
              sender: message.sender.name,
              receiver: current_company.name,
              message: message.message,
              message_type: message.message_type,
              subject: message.subject,
              created_at: message.created_at,
              updated_at: message.updated_at,
              date: message.created_at,
              description: parcel.present? ? parcel.description : nil
            }
            if message.message_type == 'Limit Increase Request'
              data.merge!(buyer_id: message.sender_id)
            else 
              data.merge!(buyer_id: message.receiver_id)
            end
            @data << data
          end
        end
        @data
      end
    end
  end
end
