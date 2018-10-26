module Api
  module V1
    class MessagesController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create]
      before_action :current_customer, only: [:index, :show, :create]
      
      def index
        all_messages = []
        if current_company
          messages = Message.joins(:sender).order("companies.name").where(receiver_id: current_company.id).where.not("message_type in (?)", ['Limit Increase Request' , 'Limit Increase Accept', 'Limit Increase Reject'])
          messages.group_by(&:proposal_id).each do |proposal_id, messages|
            all_messages << messages.last
          end
          @messages = Kaminari.paginate_array(messages_data(all_messages, params[:status], params[:description], params[:company])).page(params[:page]).per(params[:count])

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
          messages = Message.joins(:sender).order("companies.name").where(receiver_id: current_company.id).where.not("message_type in (?)", ['Limit Increase Request' , 'Limit Increase Accept', 'Limit Increase Reject'])
          messages.group_by(&:proposal_id).each do |proposal_id, messages|
            all_messages << messages.last
          end
          unread_count = all_messages.flatten.map{ |m| m if m.proposal.present? && !m.proposal.negotiations.where(from: 'seller').present? && m.proposal.status == 'negotiated' }.compact.uniq.count
          data = { count: unread_count}
          render json: { success: true, inbox: data, response_code: 200 }
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

      def messages_data(messages, status, description, company)
        @data = []
        @messages = messages
        if status.present?
          if status == 'negotiated'
            @messages = @messages.map{ |m| m if m.proposal.present? && m.proposal.negotiations.present? && m.proposal.status == status }.compact
          elsif status == 'new'
            @messages = @messages.map{ |m| m if m.proposal.present? && !m.proposal.negotiations.present? && m.proposal.status == 'negotiated' }.compact
          else  
            @messages = @messages.map{ |m| m if m.proposal.present? && m.proposal.status == status }.compact
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
          if message.proposal.present? && message.proposal.trading_parcel.present?
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
