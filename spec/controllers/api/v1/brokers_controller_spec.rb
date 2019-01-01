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

end
