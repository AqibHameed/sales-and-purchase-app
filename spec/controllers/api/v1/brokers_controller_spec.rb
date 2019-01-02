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
    @demand = create(:demand, description: @trading_parcel.description, block: false)
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

  describe '#demanding_companies' do
    context 'when unknown user want to see demands company list' do
      it 'does show message not authenticated user' do
        request.headers.merge!(authorization: 'asdasdasdasdasdsd')
        get :demanding_companies
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authenticate user want to see dashboard list and parcel id is not exist' do
      it 'does show Parcel for this id does not present' do
        get :demanding_companies, params: {id: 'al'}
        response.body.should have_content('Parcel for this id does not present')
      end
    end

    context 'when authenticate user want to see dashboard list and demand is not exist' do
      it 'does show This parcel is not demanded' do
        trading_parcel = create(:trading_parcel, broker_ids: @customer.company.id.to_s)
        get :demanding_companies, params: {id: trading_parcel.id}
        response.body.should have_content('This parcel is not demanded')
      end
    end

    context 'when authenticate user want to see dashboard list and demand is exist' do
      it 'does show the demand related to others companies' do
        get :demanding_companies, params: {id: @trading_parcel.id}
        expect(JSON.parse(response.body)['companies'].first['id']).not_to eq(@customer.company.id)
      end
    end

  end

  describe '#accept' do
    context 'when unknown user want to accept the request' do
      it 'does show message not authenticated user' do
        request.headers.merge!(authorization: 'asdasdasdasdasdsd')
        get :accept
        response.body.should have_content('Not authenticated')
      end
    end
  end

end
