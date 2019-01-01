require 'rails_helper'
RSpec.describe Api::V1::BrokersController do
  before(:all) do
  end

  before(:each) do
    @customer = create_customer
    @broker = create_broker
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

end
