module Api
  module V1
    class TenderNotificationsController <ApiController
      skip_before_action :verify_authenticity_token
      
      def create
        if current_customer
          tender_notification = TenderNotification.where(customer_id: current_customer.id, tender_id: params[:tender_id]).first
          if tender_notification.nil?
            tender_notification = TenderNotification.create(customer_id: current_customer.id, tender_id: params[:tender_id], notify: params[:notify])
          else
            tender_notification.update(notify: params[:notify])  
          end   
          if tender_notification.valid?
            render json: {success: true, tender_notification: tender_notification.as_json(only: [:tender_id, :notify]), response_code: 200 }
          else
            render json: {success: false, errors: tender_notification.errors.full_messages, response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
        end
      end

      def notifications
        if current_customer
          notifications = CustomerNotification.where(customer_id: current_customer.id)
          render json: { success: true, notifications: notification_history_data(notifications) }
        else
          render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
        end
      end

      def notification_history_data(notifications)
        @data = []
        notifications.each do |n|
          @data << {
            title: n.notification.title,
            description: n.notification.description,
            created_at: n.notification.created_at
          }
        end
        @data
      end
    end
  end
end