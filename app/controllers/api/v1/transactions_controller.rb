module Api
  module V1
    class TransactionsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:make_payment, :confirm, :reject, :seller_confirm, :seller_accept_or_reject]
      before_action :current_customer, only: [:make_payment, :confirm, :reject]
=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/transactions/make_payment
 @apiSampleRequest off
 @apiName make_payment
 @apiGroup Transactions
 @apiDescription make payment of trading parcel, if current login user, role is buyer and confirm parameter value is nil or false then this Api show the message do AGree or not
 @apiParamExample {json} Request-Example1:
{
	"transaction_id": 1,
	"amount": 200
}
 @apiSuccessExample {json} SuccessResponse1:
{
  success: true, message: "Payment is made successfully.",
  response_code: 201
}
@apiParamExample {json} Request-Example2:
{
	"transaction_id": 1,
	"amount": 200,
  "confirm": false
}
@apiSuccessExample {json} SuccessResponse2:
{
  success: true, message: "Do you Agree? Yes or No.",
  response_code: 201
}
=end
      def make_payment
        if current_company
          if current_customer.has_role?("Buyer")
              if params[:confirm] == "true"
                  payment_perform
              else
                render json: { success: true, message: 'Do you Agree? Yes or No' }
              end
          else
              payment_perform
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

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/transactions/seller_accept_or_reject
 @apiSampleRequest off
 @apiName seller_accept_or_reject
 @apiGroup Transactions
 @apiDescription seller acept or reject buyer request if seller_confirm is true then transaction will be confirm and if seller_reject is true then transaction will be reject
 @apiParamExample {json} Request-Example1:
  {
    "payment_id": 17,
    "seller_confirm": "true"
  }
  @apiSuccessExample {json} SuccessResponse1:
  {
    "success": true,
      "message": "Payment confirm successfully"
  }
  @apiParamExample {json} Request-Example2:
  {
    "id": 17,
    "seller_reject": "true"
  }
  @apiSuccessExample {json} SuccessResponse2:
  {
    "success": true,
    "message": "Payment rejected successfully"
  }
=end
      def seller_accept_or_reject
        if current_company
          @partial_payment = PartialPayment.find_by(id: params[:payment_id])
          if @partial_payment.present?
            if params[:seller_confirm] == "true"
              @partial_payment.seller_confirmed = true
              if @partial_payment.save
                render json: {success: true, message: 'Payment confirm successfully'}
              else
                render json: {success: false, message: 'Not confirm now. Please try again.'}
              end
            elsif params[:seller_reject] == "true"
              @partial_payment.seller_reject = true
              if @partial_payment.save
                TenderMailer.seller_reject_transaction(@partial_payment).deliver
                render json: { success: true, message: 'Payment rejected successfully' }
              else
                render json: { success: false, message: 'Not rejected now. Please try again.' }
              end
            end
          else
            render json: {errors: "Payment is not exist", response_code: 201}
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
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

      def seller_reject
        if current_company
          @transaction = Transaction.find(params[:id])
          @transaction.seller_reject = true
          if @transaction.save
            TenderMailer.seller_reject_transaction(@transaction).deliver
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

      def payment_perform
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
              @transaction.paid_at = DateTime.now
              #@transaction.update_column(:paid, true)
            end
            @transaction.save
            if current_customer.has_role?("Buyer")
                Message.buyer_payment_confirmation_message(current_company, @transaction, @payment)
                TenderMailer.seller_payment_received_email(@transaction, @payment).deliver rescue logger.info "Error sending email"
            else
              TenderMailer.payment_received_email(@transaction, @payment).deliver rescue logger.info "Error sending email"
            end
            render json: { success: true, message: "Payment is made successfully.", response_code: 201 }
          else
            render json: { success: false, message: "This transaction does not exist." }
          end
        else
          render json: { errors: @payment.errors.full_messages }
        end
      end
    end
  end
end
