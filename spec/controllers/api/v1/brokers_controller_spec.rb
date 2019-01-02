require 'rails_helper'
RSpec.describe Api::V1::BrokersController do
  before(:all) do
    1.upto(5) do
      @customer = create_customer
    end
    1.upto(3) do
      @broker = create_broker
    end
    @buyer = create_buyer
    @parcel = create_parcel(@customer)
    @trading_parcel = create(:trading_parcel, broker_ids: @customer.company.id.to_s, company: @customer.company)
  end

  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
  end

  describe '#company_record_on_the_basis_of_roles' do
    context 'when unknown user want to see brokers or seller list' do
      it 'does show message not authenticated user' do
        request.headers.merge!(authorization: 'asdasdasdasdasdsd')
        get :company_record_on_the_basis_of_roles
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when seller/buyer want to see brokers or seller list' do
      it 'does show list of brokers' do
        get :company_record_on_the_basis_of_roles
        response.body.should have_content(@broker.company.name)
        expect(JSON.parse(response.body)['company_record_on_the_basis_of_roles'].first['status']).to eq('SendRequest')
      end
    end

    context 'when Broker want to see brokers or seller list' do
      it 'does show list of brokers' do
        request.headers.merge!(authorization: @broker.authentication_token)
        get :company_record_on_the_basis_of_roles
        response.body.should have_content(@customer.company.name)
        expect(JSON.parse(response.body)['company_record_on_the_basis_of_roles'].first['status']).to eq('SendRequest')
      end
    end
  end

  describe '#dashboard' do
    context 'when unknown user want to see dashboard list' do
      it 'does show message not authenticated user' do
        request.headers.merge!(authorization: 'asdasdasdasdasdsd')
        get :dashboard
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authenticate user want to see dashboard list' do
      it 'does show the parcel of current company' do
        get :dashboard
        assigns(:parcels).first.company_id.should eq(@customer.id)
        response.success?.should be true
      end
    end

  end

  describe '#send_request' do
    context 'when unauthenticated Broker or buyer-seller send request' do
      it 'does show Not authenticated error' do
        request.headers.merge!(authorization: 'asdasdasdasdasdsd')
        post :send_request, params: {company: @broker.company.name}
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authenticated  buyer-seller send request to Broker' do
      it 'does show Request send successfully' do
        post :send_request, params: {company: @broker.company.name}
        response.body.should have_content('Request sent successfully')
        request = BrokerRequest.last
        expect(request.sender_id).to eq(@customer.company_id)
        expect(request.receiver_id).to eq(@broker.company_id)
        expect(request.accepted).to be false
      end
    end

    context 'when authenticated  broker send request to Broker' do
      it 'does show Request send successfully' do
        request.headers.merge!(authorization: @broker.authentication_token)
        post :send_request, params: {company: @customer.company.name}
        response.body.should have_content('Request sent successfully')
        request = BrokerRequest.last
        expect(request.sender_id).to eq(@broker.company_id)
        expect(request.receiver_id).to eq(@customer.company_id)
        expect(request.accepted).to be false
      end
    end

    context 'when authenticated  broker send request to non-existing company' do
      it 'does show company not exist' do
        request.headers.merge!(authorization: @broker.authentication_token)
        post :send_request, params: {company: 'unknown company'}
        response.body.should have_content('There is no company with this name')
      end
    end

    context 'when authenticated  seller/buyer send request to non-existing company' do
      it 'does show company not exist' do
        post :send_request, params: {company: 'unknown company'}
        response.body.should have_content('There is no company with this name')
      end
    end

    context 'when authenticated  seller/buyer send request and they already requested' do
      it 'does show they are already connected' do
        request = create(:broker_request,
                         seller_id: @customer.company_id,
                         broker_id: @broker.company_id,
                         sender_id: @broker.company_id,
                         receiver_id: @customer.company_id)
        post :send_request, params: {company: @broker.company.name}
        response.body.should have_content('status is already requested')
      end
    end

    context 'when authenticated  seller/buyer send request and they already connected' do
      it 'does show they are already connected' do
        request = create(:broker_request,
                         seller_id: @customer.company_id,
                         broker_id: @broker.company_id,
                         sender_id: @broker.company_id,
                         receiver_id: @customer.company_id)
        request.update_attributes(accepted: true)
        post :send_request, params: {company: @broker.company.name}
        response.body.should have_content('You both are already connected')
      end
    end

    context 'when authenticated  broker send request and they already connected' do
      it 'does show they are already connected' do
        request.headers.merge!(authorization: @broker.authentication_token)
        request = create(:broker_request,
                         seller_id: @customer.company_id,
                         broker_id: @broker.company_id,
                         sender_id: @broker.company_id,
                         receiver_id: @customer.company_id)
        request.update_attributes(accepted: true)
        post :send_request, params: {company: @customer.company.name}
        response.body.should have_content('You both are already connected')
      end
    end
  end

  describe '#show_requests' do
    context 'when unauthenticated user want to see requests' do
      it 'does show Not authenticated' do
        request.headers.merge!(authorization: 'jsdadadadasdasdasdas')
        get :show_requests
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authenticted broker want to see requests came from any buyers/sellers' do
      it 'does show list of requests' do
        get :show_requests
        JSON.parse(response.body)["requests"].empty?.should be true
        request = create(:broker_request,
                         seller_id: @customer.company_id,
                         broker_id: @broker.company_id,
                         sender_id: @broker.company_id,
                         receiver_id: @customer.company_id)
        get :show_requests
        JSON.parse(response.body)["requests"].empty?.should be false
        JSON.parse(response.body)["requests"].first["broker_name"].should eq(@broker.name)
        JSON.parse(response.body)["requests"].first["broker_company"].should eq(@broker.company.name)
      end
    end

    context 'when authenticted seller/buyer want to see requests came from any brokers' do
      it 'does show list of requests' do
        request.headers.merge!(authorization: @broker.authentication_token)
        get :show_requests
        JSON.parse(response.body)["requests"].empty?.should be true
        request = create(:broker_request,
                         seller_id: @customer.company_id,
                         broker_id: @broker.company_id,
                         sender_id: @customer.company_id,
                         receiver_id: @broker.company_id)
        get :show_requests
        JSON.parse(response.body)["requests"].empty?.should be false
        JSON.parse(response.body)["requests"].first["seller_name"].should eq(@customer.name)
        JSON.parse(response.body)["requests"].first["seller_company"].should eq(@customer.company.name)
      end
    end
  end

  describe '#remove' do
    context 'when unauthenticated user try to remove connected user' do
      it 'does show not authenticated' do
        request.headers.merge!(authorization: 'custweomer.autsdhentication_towerken')
        post :remove, params: {request_id: 1}
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when seller/buyer try to remove connected broker' do
      it 'does show successfully removed' do
        request = create(:broker_request,
                         seller_id: @customer.company_id,
                         broker_id: @broker.company_id,
                         sender_id: @customer.company_id,
                         receiver_id: @broker.company_id)
        request.update_attributes(accepted: true)
        post :remove, params: {request_id: request.id}
        response.body.should have_content('You have removed successfully.')
      end
    end
  end

end
