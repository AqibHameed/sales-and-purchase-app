require 'rails_helper'
RSpec.describe Api::V1::CustomersController do
  before(:all) do
    create_roles
    @customer = create_customer
    @buyer = create_buyer
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
  end

  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
    1.upto(5) do
      @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
      create(:transaction, buyer_id: @buyer.company_id,
             seller_id: @customer.company_id,
             trading_parcel_id: @parcel.id,
             diamond_type: 'polished')
    end
    1.upto(5) do
      @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
      create(:transaction, buyer_id: @buyer.company_id,
             seller_id: @customer.company_id,
             trading_parcel_id: @parcel.id,
             diamond_type: 'Rough')
    end

  end

  describe '#access_tiles' do
    # context 'when unauhorized user want to access the api' do
    #   it 'does show Not Authenticated ' do
    #     request.headers.merge!(authorization: 'unknown_token')
    #     get :access_tiles, params: {tab: 'history'}
    #     response.body.should have_content('Not authenticated')
    #   end
    # end


    context 'when authorized Trader want to access the api' do
      it 'does count increase of related tab' do
        get :access_tiles, params: {tab: 'history'}
      end
    end
  end
end