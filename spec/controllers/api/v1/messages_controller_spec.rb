require 'rails_helper'
RSpec.describe Api::V1::MessagesController do
  before(:all) do
    create_roles
    @customer = create_customer
    @buyer = create_buyer
    @parcel = create(:trading_parcel, customer: @buyer, company: @customer.company)
    @proposal = create(:proposal, buyer_id: @buyer.company.id,
           seller_id: @customer.company.id,
           trading_parcel_id: @parcel.id,
           price: "4000", credit: "1500")
    @message = create(:message, proposal_id: @proposal.id, receiver_id: @customer.company.id, sender_id: @buyer.company.id)
  end
  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
  end
  describe '#create' do
    context 'when unauthorized user to create the message' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'wetasdetoken')
        post :create
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user to create the message' do
      it 'does show error un authorized user' do
        post :create, params: {message: {subject: 'You have a new proposal',
                                         message: 'Message Created Successfully',
                                         message_type: 'Proposal',
                                         receiver_id: 'al'
                                        }}
        response.body.should have_content('Message Created Successfully')
        expect(response.success?).to eq(true)
      end
    end
  end

  describe '#show' do
    context 'when authorized user to show the message' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'wetasdetoken')
        put :show, params: {id: 'al'}
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user to show the message if message id not exist' do
      it 'does show the message Message id should be present' do
        put :show, params: {id: ''}
        response.body.should have_content('Message id should be present')
      end
    end

    context 'when authorized user to show the message if message is not exist' do
      it 'does show the message Message id should be present' do
        put :show, params: {id: 'al'}
        response.body.should have_content('Message does not exists for this id')
      end
    end

    context 'when authorized user to show the message if message is  exist' do
      it 'does match the response of message accordingly' do
        put :show, params: {id: @message.id}
        expect(@buyer.company.name).to eq(JSON.parse(response.body)['message']['sender'])
        expect(@customer.company.name).to eq(JSON.parse(response.body)['message']['receiver'])
        expect(response.success?).to eq(true)
      end
    end

  end
end