require 'rails_helper'
RSpec.describe Api::V1::CustomersController do
  before(:all) do
    create_roles
    @customer = create_customer
    @buyer = create_buyer
    @broker = create_broker
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
    @permissions = {sender_id: @customer.company_id,
                    receiver_id: @buyer.company_id,
                    secure_center: true,
                    seller_score: true,
                    status: 'accepted',
                    buyer_score: true}
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



  describe '#feedback_rating' do
    context 'when unauhorized user want to access the feedback_rating api' do
      it 'does show Not Authenticated ' do
        request.headers.merge!(authorization: 'unknown_token')
        get :feedback_rating
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when auhorized user want to access the feedback_rating api' do
      it 'does show Not Authenticated ' do
        get :feedback_rating, params: {trading_parcel_id: @parcel.id, rating: 5, comment: "It is good"}
        expect(JSON.parse(response.body)['feedback']['trading_parcel_id']).to eq(@parcel.id)
        expect(JSON.parse(response.body)['feedback']['feedback_rating']).to eq(5)
        expect(JSON.parse(response.body)['feedback']['comments']).to eq('It is good')
      end
    end

    context 'when auhorized user want to access the feedback_rating api' do
      it 'does show Not Authenticated ' do
        get :feedback_rating, params: {trading_parcel_id: @parcel.id, rating: 6, comment: "It is bad"}
        expect(JSON.parse(response.body)['feedback']['trading_parcel_id']).to eq(@parcel.id)
        expect(JSON.parse(response.body)['feedback']['feedback_rating']).to eq(6)
        expect(JSON.parse(response.body)['feedback']['comments']).to eq('It is bad')
      end
    end

    context 'when auhorized user want to access the feedback_rating api' do
      it 'does show Not Authenticated ' do
        get :feedback_rating
        response.body.should have_content('Record not found')
      end
    end

  end



  describe "#seller_scores" do
    context 'when authenticated user want to see his own seller score'do
      it 'does show his seller score' do
        get :seller_scores, params: {receiver_id: @customer.company_id}
        expect(JSON.parse(response.body)['success']).to be true
        JSON.parse(response.body)['scores'].present?
        JSON.parse(response.body)['scores'].last['seller_score'].present?
      end
    end

    context 'when authenticated user want to other buyers seller score without permission'do
      it 'does show permission Access denied' do
        get :seller_scores, params: {receiver_id: @buyer.company_id}
        response.body.should have_content('permission Access denied')
      end
    end

    context 'when authenticated user want to other buyers seller score with permission'do
      it 'does show his seller score' do
        @permission_request = create_permission_request(@permissions)
        get :seller_scores, params: {receiver_id: @buyer.company_id}
        expect(JSON.parse(response.body)['success']).to be true
        JSON.parse(response.body)['scores'].present?
        JSON.parse(response.body)['scores'].last['seller_score'].present?
      end
    end

    context 'when unauthenticated user want to other buyers seller score with permission'do
      it 'does show Not authenticated' do
        request.headers.merge!(authorization: 'unknown token')
        @permission_request = create_permission_request(@permissions)
        get :seller_scores, params: {receiver_id: @buyer.company_id}
        response.body.should have_content('Not authenticated')
      end
    end
  end


  describe "#buyer_scores" do
    context 'when authenticated user want to see his own buyer score'do
      it 'does show his seller score' do
        get :buyer_scores, params: {receiver_id: @customer.company_id}
        expect(JSON.parse(response.body)['success']).to be true
        JSON.parse(response.body)['scores'].present?
        JSON.parse(response.body)['scores'].last['buyer_score'].present?
      end
    end

    context 'when authenticated user want to other buyers buyer score without permission'do
      it 'does show permission Access denied' do
        get :buyer_scores, params: {receiver_id: @buyer.company_id}
        response.body.should have_content('permission Access denied')
      end
    end

    context 'when authenticated user want to other buyers buyer score with permission'do
      it 'does show his seller score' do
        @permission_request = create_permission_request(@permissions)
        get :buyer_scores, params: {receiver_id: @buyer.company_id}
        expect(JSON.parse(response.body)['success']).to be true
        JSON.parse(response.body)['scores'].present?
        JSON.parse(response.body)['scores'].last['buyer_score'].present?
      end
    end

    context 'when unauthenticated user want to other buyers buyer score with permission'do
      it 'does show Not authenticated' do
        request.headers.merge!(authorization: 'unknown token')
        @permission_request = create_permission_request(@permissions)
        get :buyer_scores, params: {receiver_id: @buyer.company_id}
        response.body.should have_content('Not authenticated')
      end
    end
  end


end