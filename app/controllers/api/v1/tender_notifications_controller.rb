module Api
  module V1
    class TenderNotificationsController <ApiController
      skip_before_action :verify_authenticity_token
      def create
        if current_customer
          tender_notification = TenderNotification.new(customer_id: current_customer.id, tender_id: params[:tender_id], notify: params[:notify])
          if tender_notification.save
            render json: {success: true, tender_notification: tender_notification.as_json(only: [:tender_id, :notify]) }
          else
            render json: {success: false, errors: tender_notification.errors.full_messages }
          end
        else
          render json: { errors: "Not authenticated"}, status: :unauthorized
        end
      end
    end
  end
end