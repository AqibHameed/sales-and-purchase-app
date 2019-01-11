require 'rails_helper'
RSpec.describe Api::V1::CustomersController do
  before(:all) do
    create_roles
    @customer = create_customer
    @buyer = create_buyer
    @broker = create_broker
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
  end

  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
  end

  describe '#access_tiles' do
    context 'when unauhorized user want to access the api' do
      it 'does show Not Authenticated ' do
        request.headers.merge!(authorization: 'unknown_token')
        get :access_tiles, params: {tab: 'history'}
        response.body.should have_content('Not authenticated')
      end
    end


    context 'when authorized Trader want to access the api' do
      it 'does count increase of related tab' do
        get :access_tiles, params: {tab: 'history'}
        expect(JSON.parse(response.body)['messages'].first['History']).to eq(true)
        expect(JSON.parse(response.body)['messages'].first['count']).to eq(@customer.tiles_count.history)
      end
    end

    context 'when authorized Trader want to access the api' do
      it 'does count increase of related tab' do
        get :access_tiles, params: {tab: 'record_sale'}
        expect(JSON.parse(response.body)['messages'].first['Record Sale']).to eq(true)
        expect(JSON.parse(response.body)['messages'].first['count']).to eq(1)
      end
    end

    context 'when authorized broker want to access the api' do
      it 'does count increase of related tab' do
        get :access_tiles, params: {tab: 'sell'}
        expect(JSON.parse(response.body)['messages'].first['Sell']).to eq(true)
        expect(JSON.parse(response.body)['messages'].first['count']).to eq(1)
      end
    end

    context 'when authorized broker want to access the api' do
      it 'does count increase of related tab' do
        request.headers.merge!(authorization: @broker.authentication_token)
        get :access_tiles, params: {tab: 'upcoming_tenders'}
        expect(JSON.parse(response.body)['messages'].first['Upcoming Tenders']).to eq(true)
        expect(JSON.parse(response.body)['messages'].first['count']).to eq(@broker.tiles_count.upcoming_tenders)
      end
    end

    context 'when authorized buyer want to access the api' do
      it 'does count increase of related tab' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        request.content_type = 'application/json'
        get :access_tiles, params: {tab: 'history'}
        expect(JSON.parse(response.body)['messages'].first['History']).to eq(true)
        expect(JSON.parse(response.body)['messages'].first['count']).to eq(@buyer.tiles_count.history)
      end
    end
  end
end