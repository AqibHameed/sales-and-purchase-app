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
    @proposal_message = Message.create_new(@proposal)
    @permissions = {sender_id: @customer.company_id,
                    receiver_id: @buyer.company_id,
                    secure_center: true,
                    seller_score: true,
                    buyer_score: true}
    @negotiation = create(:negotiation, proposal: @proposal)
  end
  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
  end

  describe '#index' do
    context 'when unauthorized user to access the message' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'wetasdetoken')
        get :index
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user to access the message' do
      it 'does show the message you have new proposal' do
        get :index
        expect(@proposal_message.subject).to eq(JSON.parse(response.body)['messages'].first['subject'])
      end
    end

    context 'when authorized user to access the message' do
      it 'does show the message Your proposal is accepted' do
        proposal = create(:proposal, buyer_id: @buyer.company.id,
                          seller_id: @customer.company.id,
                          trading_parcel_id: @parcel.id,
                          price: "4000", credit: "1500", status: 1)
        accept_proposal = Message.accept_proposal(proposal, @customer)
        get :index, params: {status: 'accepted'}
        expect(accept_proposal.subject).to eq('Your proposal is accepted.')
      end
    end

    context 'when authorized user to access the message' do
      it 'does show the message Your proposal is rejected' do
        proposal = create(:proposal, buyer_id: @buyer.company.id,
                          seller_id: @customer.company.id,
                          trading_parcel_id: @parcel.id,
                          price: "4000", credit: "1500", status: 2)
        reject_proposal = Message.reject_proposal(proposal, @customer)
        get :index
        expect(reject_proposal.subject).to eq('Your proposal is rejected.')
      end
    end

    context 'when authorized user to access the message' do
      it 'does show the message Buyer accepted your negotiated proposal' do
        proposal = create(:proposal, buyer_id: @buyer.company.id,
                          seller_id: @customer.company.id,
                          trading_parcel_id: @parcel.id,
                          price: "4000", credit: "1500", status: 2)
        buyer_accept_proposal = Message.buyer_accept_proposal(proposal, @customer)
        get :index
        expect(buyer_accept_proposal.subject).to eq('Buyer accepted your negotiated proposal.')
      end
    end

    context 'when authorized user to access the message' do
      it 'does show the message Buyer rejected your negotiated proposal' do
        proposal = create(:proposal, buyer_id: @buyer.company.id,
                          seller_id: @customer.company.id,
                          trading_parcel_id: @parcel.id,
                          price: "4000", credit: "1500", status: 2)
        buyer_reject_proposal = Message.buyer_reject_proposal(proposal, @customer)
        get :index
        expect(buyer_reject_proposal.subject).to eq('Buyer rejected your negotiated proposal.')
        expect(response.success?).to eq(true)
      end
    end

    context 'when authorized user to access the message' do
      it 'does show the message security center request messages' do
        permission_request = create_permission_request(@permissions)
        request.headers.merge!(authorization: @buyer.authentication_token)
        message = Message.send_request_for_live_monitoring(permission_request)
        get :index, params: {status: 'new'}
        response.body.should have_content(message.subject)
        expect(JSON.parse(response.body)['messages'].first['sender']).to eq(@customer.company.name)
      end
    end

    context 'when authorized user to access the message' do
      it 'does show the message Buyer payment messages' do
        transaction = create_transaction(@buyer, @customer, @parcel)
        message = Message.buyer_payment_confirmation_message(@customer.company, transaction)
        get :index, params: {status: 'new'}
        response.body.should have_content('Your Payment is confirmed.')
        expect(JSON.parse(response.body)['messages'].last['id']).to eq(message.id)
        expect(JSON.parse(response.body)['messages'].last['sender']).to eq(message.sender.name)
        expect(JSON.parse(response.body)['messages'].last['receiver']).to eq(message.receiver.name)
      end
    end
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
    context 'when unauthorized user to show the message' do
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

  describe '#unread_count' do
    context 'when unauthorized user to read the unread message count' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'wetasdetoken')
        get :unread_count
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user to read the unread message count' do
      it 'does show number of count message' do
        get :unread_count
        JSON.parse(response.body)['inbox']['count'].should be > 0
        expect(response.success?).to eq(true)
      end
    end
  end
end