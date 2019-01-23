require 'rails_helper'
RSpec.describe Api::V1::CustomersController do
  before(:all) do
    create_roles
    @customer = create_customer
    # @com_id = @customer.company.id
    @buyer = create_buyer
    @broker = create_broker
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
  end

  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
    1.upto(5) do
    create(:transaction, buyer_id: @buyer.company_id,
           seller_id: @customer.company_id,
           trading_parcel_id: @parcel.id,
           due_date: Date.current + 30,
           created_at: 10.days.ago,
           paid: true
        )
    end

    1.upto(5) do
      create(:transaction, buyer_id: @buyer.company_id,
             seller_id: @customer.company_id,
             trading_parcel_id: @parcel.id,
             due_date: Date.current + 30,
             created_at: 10.days.ago,
             paid: false
      )
    end
end
  # describe '#access_tiles' do
  #   context 'when unauhorized user want to access the api' do
  #     it 'does show Not Authenticated ' do
  #       request.headers.merge!(authorization: 'unknown_token')
  #       get :access_tiles, params: {tab: 'history'}
  #       response.body.should have_content('Not authenticated')
  #     end
  #   end
  #
  # #
  #   context 'when authorized Trader want to access the api' do
  #     it 'does count increase of related tab' do
  #       get :access_tiles, params: {tab: 'history'}
  #       expect(JSON.parse(response.body)['messages'].first['History']).to eq(true)
  #       expect(JSON.parse(response.body)['messages'].first['count']).to eq(@customer.tiles_count.history)
  #     end
  #   end
  #
  #   context 'when authorized Trader want to access the api' do
  #     it 'does count increase of related tab' do
  #       get :access_tiles, params: {tab: 'record_sale'}
  #       expect(JSON.parse(response.body)['messages'].first['Record Sale']).to eq(true)
  #       expect(JSON.parse(response.body)['messages'].first['count']).to eq(1)
  #     end
  #   end
  # #
  #   context 'when authorized broker want to access the api' do
  #     it 'does count increase of related tab' do
  #       get :access_tiles, params: {tab: 'sell'}
  #       expect(JSON.parse(response.body)['messages'].first['Sell']).to eq(true)
  #       expect(JSON.parse(response.body)['messages'].first['count']).to eq(1)
  #     end
  #   end
  # #
  #   context 'when authorized broker want to access the api' do
  #     it 'does count increase of related tab' do
  #       request.headers.merge!(authorization: @broker.authentication_token)
  #       get :access_tiles, params: {tab: 'upcoming_tenders'}
  #       expect(JSON.parse(response.body)['messages'].first['Upcoming Tenders']).to eq(true)
  #       expect(JSON.parse(response.body)['messages'].first['count']).to eq(@broker.tiles_count.upcoming_tenders)
  #     end
  #   end
  # #
  #   context 'when authorized buyer want to access the api' do
  #     it 'does count increase of related tab' do
  #       request.headers.merge!(authorization: @buyer.authentication_token)
  #       request.content_type = 'application/json'
  #       get :access_tiles, params: {tab: 'history'}
  #       expect(JSON.parse(response.body)['messages'].first['History']).to eq(true)
  #       expect(JSON.parse(response.body)['messages'].first['count']).to eq(@buyer.tiles_count.history)
  #      end
  #   end
  # end


  describe '#info' do
    # context 'when not permit user want to access the info api' do
    #   it 'does show Not company_not_exist ' do
    #     get :info
    #     response.body.should have_content('company id not exist')
    #   end
    # end

    # context 'when permited user want to access the info api' do
    #   it 'does show permissons are not allowed ' do
    #     get :info, params: {receiver_id: 12}
    #     response.body.should have_content('permission Access denied')
    #   end
    # end


    # context 'when unauthorized user want to access the info api' do
    #   it 'does show un-authoruized user ' do
    #     # request.headers.merge!(authorization: 'unknown_token_laylo')
    #     get :info, params: {receiver_id: @customer.company.id}
    #     binding.pry
    #    response.body.should have_content('Not authenticated')
    #   end
    # end



    # context 'when authorized user want to access the info api' do
    #   it 'does check pending transection ' do
    #     transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id)
    #     get :info , params:{receiver_id: @customer.company.id}
    #    expect(JSON.parse(response.body)['transactions']['total']).to eq(transactions.size)
    #   end
    # end

  end
 end