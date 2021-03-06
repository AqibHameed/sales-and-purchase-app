require 'rails_helper'
RSpec.describe Api::V1::TransactionsController do
  before(:all) do
    create_roles
    @customer = create_customer
    @buyer = create_buyer
    @parcel = create_parcel(@customer)

    @transaction =  create_transaction(@buyer, @customer, @parcel)
    @payment = create(:partial_payment, company_id: @buyer.company_id, transaction_id: @transaction.id)
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

    context 'when authorized buyer make a payment and transaction does exist' do
      it 'does show the message Do you Agree? Yes or No' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        post :make_payment, params: {
            transaction_id: @transaction.id,
            amount: 3500
        }
        response.body.should have_content('Do you Agree? Yes or No')
      end
    end

    context 'when authorized buyer make a payment and transaction does exist and buyer confirm' do
      it 'does show the transaction not complete' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        parcel = TradingParcel.create(description: Faker::Lorem.sentence, source: "OutSide Goods", credit_period: 0, total_value: 0,
                                      price: 0, weight: 0, diamond_type: "Rough", customer_id: @customer.id, company_id: @customer.company.id)
        transaction =  create_transaction(@buyer, @customer, parcel)
        post :make_payment, params: {
            confirm: "true",
            transaction_id: transaction.id,
            amount: 0
        }
        assigns[:transaction]['paid'].should eq(false)
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

    context 'when authorized seller accept the payment, and transaction not exist' do
      it 'does show an error Payment is not exist' do
        post :seller_accept_or_reject
        response.body.should have_content('"Payment is not exist')
      end
    end

    context 'when authorized seller accept the transaction' do
      it 'does match the seller confirmed value true' do
        post :seller_accept_or_reject, params: {payment_id: @payment.id, seller_confirm: "true"}
        assigns[:partial_payment]['payment_status'].should eq("confirmed")
      end
    end

    context 'when authorized seller accept the transaction' do
      it 'does show the message Do you Agree? Yes or No' do
        parcel = TradingParcel.create(description: Faker::Lorem.sentence, source: "OutSide Goods", credit_period: 0, total_value: 0,
                                      price: 0, weight: 0, diamond_type: "Rough", customer_id: @customer.id, company_id: @customer.company.id)
        transaction =  create_transaction(@buyer, @customer, parcel)
        payment = PartialPayment.create(amount: 0, company_id: @buyer.company_id, transaction_id: transaction.id)
        post :seller_accept_or_reject, params: {
            seller_confirm: "true",
            payment_id: payment.id
        }
        assigns[:transaction]['paid'].should eq(false)
      end
    end


    context 'when authorized user accept the payment' do
      it 'does show the message Payment confirm successfully' do
        post :seller_accept_or_reject, params: {payment_id: @payment.id, seller_confirm: "true"}
        response.body.should have_content('Payment confirm successfully')
      end
    end

    context 'when authorized user reject the payment' do
      it 'does match the seller payment value true' do
        transaction =  create_transaction(@buyer, @customer, @parcel)
        post :seller_accept_or_reject, params: {payment_id: @payment.id, seller_reject: "true"}
        assigns[:partial_payment]['payment_status'].should eq("rejected")
      end
    end

    context 'when authorized  reject the payment' do
      it 'does match the message Payment rejected successfully' do
        post :seller_accept_or_reject, params: {payment_id: @payment.id, seller_reject: "true"}
        response.body.should have_content('Payment rejected successfully')
      end
    end


  end

end