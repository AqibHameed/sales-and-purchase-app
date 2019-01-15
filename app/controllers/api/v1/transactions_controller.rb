module Api
  module V1
    class TransactionsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:make_payment, :confirm, :reject, :seller_confirm]
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
 @api {post} /api/v1/transactions/seller_confirm
 @apiSampleRequest off
 @apiName seller_confirm
 @apiGroup Transactions
 @apiDescription seller_confirmation_of_amount
 @apiParamExample {json} Request-Example:
{
	"id": 53,
	"amount": 30

}
 @apiSuccessExample {json} SuccessResponse:
{
  "success": true,
    "message": "Transaction confirm successfully"
}
=end
      def seller_confirm
        if current_company
          @transaction = Transaction.find(params[:id])
          @transaction.seller_confirmed = true
          if @transaction.save
            @transaction.create_parcel_for_seller
            render json: {success: true, message: 'Transaction confirm successfully'}
          else
            render json: {success: false, message: 'Not confirm now. Please try again.'}
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
              #@transaction.update_column(:paid, true)
            end
            @transaction.save

            if current_customer.has_role?("Buyer")
                Message.buyer_payment_confirmation_message(current_company, @transaction)
            end
            TenderMailer.payment_received_email(@transaction, @payment).deliver rescue logger.info "Error sending email"
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
