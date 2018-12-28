require 'rails_helper'
RSpec.describe Api::V1::TransactionsController do
  before(:all) do
    @customer = create_customer
    @buyer = create_buyer
    @parcel = create_parcel(@customer)

    @transaction =  create_transaction(@buyer, @customer, @parcel)
  end

  context 'when unauthorized user make a payment' do
    it 'does show error un authorized user' do
      post :make_payment, params: {
          transaction_id: @transaction.id,
          amount: 4500
      }
      response.body.should have_content('Not authenticated')

    end
  end

  context 'when authorized user make a payment' do
    it 'does show error when remaining amount grater than the remaining amount' do
      request.headers.merge!(authorization: @customer.authentication_token)
      post :make_payment, params: {
          transaction_id: @transaction.id,
          amount: 4500
      }
      response.body.should have_content('Amount should be less than the total amount to be paid')

    end
  end

  context 'when authorized user make a payment and transaction does exist' do
    it 'does show the message payment is made successfully' do
      request.headers.merge!(authorization: @customer.authentication_token)
      post :make_payment, params: {
          transaction_id: @transaction.id,
          amount: 3500
      }
      response.body.should have_content('Payment is made successfully')
      expect(response.status).to eq(200)

    end

  end
end