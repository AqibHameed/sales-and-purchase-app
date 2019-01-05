require 'rails_helper'
RSpec.describe Api::V1::MessagesController do
  before(:all) do
    create_roles
    @customer = create_customer
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
      end
    end

  end
end