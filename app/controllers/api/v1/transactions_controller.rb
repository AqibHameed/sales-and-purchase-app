module Api
  module V1
    class TransactionsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:make_payment, :confirm, :reject]
      before_action :current_customer, only: [:make_payment, :confirm, :reject]

      def make_payment
        if current_company
          @payment = PartialPayment.new(payment_params)
          @payment.company_id = current_company.id
          if @payment.save
            @transaction = Transaction.where(id: @payment.transaction_id).first
            if @transaction.present?
              amount = @transaction.remaining_amount
              @transaction.remaining_amount = amount - @payment.amount
              #@transaction.update_column(:remaining_amount, amount - @payment.amount)
              if @transaction.remaining_amount == 0
                @transaction.paid = true
                #@transaction.update_column(:paid, true)
              end
              @transaction.save
              TenderMailer.payment_received_email(@transaction, @payment).deliver rescue logger.info "Error sending email"
              render json: { success: true, message: "Payment is made successfully.", response_code: 201 }
            else
              render json: { success: false, message: "This transaction does not exist." }
            end
          else
            render json: { errors: @payment.errors.full_messages }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def confirm
        if current_company
          @transaction = Transaction.find(params[:id])
          @transaction.buyer_confirmed = true
          if @transaction.save
            @transaction.create_parcel_for_buyer
            render json: { success: true, message: 'Transaction confirm successfully' }
          else
            render json: { success: false, message: 'Not confirm now. Please try again.' }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end  
      end

      def reject
        if current_company
          @transaction = Transaction.find(params[:id])
          @transaction.buyer_reject = true
          if @transaction.save
            TenderMailer.buyer_reject_transaction(@transaction).deliver
            render json: { success: true, message: 'Transaction rejected successfully' }
          else
            render json: { success: false, message: 'Not rejected now. Please try again.' }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      private
      def payment_params
        params.permit(:transaction_id, :amount)
      end
    end
  end
end
