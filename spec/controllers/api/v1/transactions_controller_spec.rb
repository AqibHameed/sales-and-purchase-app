require 'rails_helper'
RSpec.describe Api::V1::TransactionsController do
  before(:all) do
    create_roles
    @customer = create_customer
    @buyer = create_buyer
    @parcel = create_parcel(@customer)

    @transaction =  create_transaction(@buyer, @customer, @parcel)
  end

  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
  end

  describe '#make_payment' do
    context 'when unauthorized user make a payment' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'unknown_token')
        post :make_payment, params: {
            transaction_id: @transaction.id,
            amount: 4500
        }
        response.body.should have_content('Not authenticated')

      end
    end

    context 'when authorized user make a payment' do
      it 'does show error when remaining amount grater than the remaining amount' do
        post :make_payment, params: {
            transaction_id: @transaction.id,
            amount: 4500
        }
        response.body.should have_content('Amount should be less than the total amount to be paid')

      end
    end

    context 'when authorized user make a payment and transaction does exist' do
      it 'does show the message payment is made successfully' do
        post :make_payment, params: {
            transaction_id: @transaction.id,
            amount: 3500
        }
        response.body.should have_content('Payment is made successfully')
        expect(response.status).to eq(200)

      end

    end
  end

  describe '#confirm' do
    context 'when unauthorized user confirm a transaction' do
      it 'does show an error un authorized user' do
        request.headers.merge!(authorization: 'unknown_token')
        post :confirm, params: {
            id: @transaction.id
        }
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user confirm a transaction' do
      it 'does show the message Transaaction confirm successfully' do
        post :confirm, params: {
            id: @transaction.id
        }

        response.body.should have_content('Transaction confirm successfully')
        expect(response.status).to eq(200)
      end

    end

  end

  describe '#reject' do
    context 'when unauthorized user reject a transaction' do
      it 'does show an error un authorized user' do
        request.headers.merge!(authorization: 'unknown_token')
        post :reject, params: {
            id: @transaction.id
        }
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user reject a transaction' do
      it 'does show the message transaction rejected successfully' do
        post :reject, params: {
            id: @transaction.id
        }
        response.body.should have_content('Transaction rejected successfully')
        expect(response.status).to eq(200)
      end
    end
  end

  describe '#seller_accept_or_reject' do
    context 'when unauthorized user accept or reject the transaction' do
      it 'does show an error un authorized user' do
        request.headers.merge!(authorization: 'unknown_token')
        post :seller_accept_or_reject
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when unauthorized user accept or reject the transaction' do
      it 'does show an error un authorized user' do
        post :seller_accept_or_reject
        response.body.should have_content('Transaction is not exist')
      end
    end
  end

end