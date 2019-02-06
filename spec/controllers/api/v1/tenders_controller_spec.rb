require 'rails_helper'
RSpec.describe Api::V1::TendersController do
  before(:all) do
    create_roles
    @customer = create_customer
    @supplier = create(:supplier)
    # @tender = create_tender
    @tender = create(:tender, supplier: @supplier, open_date: DateTime.current - 1, close_date: DateTime.current + 2)
    @tender = create(:tender, supplier: @supplier, open_date: DateTime.current + 1, close_date: DateTime.current + 2)
    @stone = create(:stone, tender_id: @tender.id)
    @tender_winner = create(:tender_winner, tender: @tender)
  end

  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
  end

  describe '#tender_index' do

    context 'when authorized  tender access the api' do
      it 'does show the tender according to location' do
        get :index, params: {location: @tender.country}
        expect(JSON.parse(response.body)['tenders'].first['country']).to eq(@tender.country)
      end
    end

    context 'when authorized  tender access the api' do
      it 'does shows the tender according to month' do
        get :index, params: {month: @tender.open_date.to_date.mon}
        expect(JSON.parse(response.body)['tenders'].first['start_date'].to_date.mon).to eq(@tender.open_date.to_date.mon)
      end
    end
    context 'when authorized  tender access the api' do
      it 'does show the tender according to supplier_id' do
        get :index, params: {supplier: @tender.supplier_id}
        tender = Tender.find_by(id: JSON.parse(response.body)['tenders'].first['id'])
        expect(tender.supplier.name).to eq(@tender.supplier.name)
      end
    end
    context 'when authorized  tender access the api' do
      it 'does show the upcoming tenders' do
        tender = create(:tender, supplier: @supplier, open_date: DateTime.current + 1, close_date: DateTime.current + 2)
        get :index
        expect(JSON.parse(response.body)['tenders'].last['start_date'].to_datetime).to be > DateTime.current
      end
    end

    context 'when authorized  tender access the api' do
      it 'does show the past tenders' do
        tender = create(:tender, supplier: @supplier, open_date: DateTime.current - 2, close_date: DateTime.current - 1)
        get :index
        expect(JSON.parse(response.body)['tenders'].first['end_date'].to_datetime).to be < DateTime.current
      end
    end

  end


  describe '#tender_upcomming' do
    context 'when authorized  tender access the api' do
      it 'does show the upcoming tenders' do
        get :index
        expect(JSON.parse(response.body)['tenders'].last['start_date'].to_datetime).to be > DateTime.current
      end
    end

    context 'when authorized  tender access the api' do
      it 'does show the tender according to loation' do
        get :index, params: {location: @tender.country}
        expect(JSON.parse(response.body)['tenders'].first['country']).to eq(@tender.country)
      end
    end

    context 'when authorized  tender access the api' do
      it 'does shiw the tender according to month' do
        get :index, params: {month: @tender.open_date.to_date.mon}
        expect(JSON.parse(response.body)['tenders'].first['start_date'].to_date.mon).to eq(@tender.open_date.to_date.mon)
      end
    end
    context 'when authorized  tender access the api' do
      it 'does show the tender according to supplier_id' do
        get :index, params: {supplier: @tender.supplier_id}
        tender = Tender.find_by(id: JSON.parse(response.body)['tenders'].first['id'])
        expect(tender.supplier.name).to eq(@tender.supplier.name)
      end
    end
  end

  # describe '#stone_parcel' do
  #   context 'when unknown user want to access stone parcel Api' do
  #     it 'does show message not authenticated user' do
  #       request.headers.merge!(authorization: 'asdasdasdasdasdsd')
  #       post :stone_parcel
  #       response.body.should have_content('Not authenticated')
  #     end
  #   end
  #
  #   context 'when authorized user want to access stone parcel Api' do
  #     it 'does show message not authenticated user' do
  #       post :stone_parcel
  #       response.body.should have_content('Parcel not found')
  #     end
  #   end
  #
  #   context 'when authorized user want to access stone parcel Api' do
  #     it 'does show message not authenticated user' do
  #       post :stone_parcel, params: {id: @stone.id}
  #       expect(JSON.parse(response.body)['response_code']).to eq(200)
  #     end
  #   end
  #
  #   context 'when authorized user want to access stone parcel Api' do
  #     it 'does show message not authenticated user' do
  #       post :stone_parcel, params: {id: @stone.id, comments: "It is good", parcel_rating: 5}
  #       expect(JSON.parse(response.body)['stone_parcel']['comments']).to eq('It is good')
  #       expect(JSON.parse(response.body)['stone_parcel']['parcel_rating']).to eq(5)
  #       expect(JSON.parse(response.body)['response_code']).to eq(200)
  #     end
  #   end
  # end

  describe '#tender_winners' do
    context 'when user access tender_winners if tender winner not found' do
      it 'does match the status 200' do
        get :tender_winners
        expect(JSON.parse(response.body)['response_code']).to eq(200)
      end
    end

    context 'when user access tender_winners if tender winner is found' do
      it 'does match the record' do
        get :tender_winners, params: {tender_id: @tender.id}
        expect(JSON.parse(response.body).first.last.last['description']).to eq(@tender_winner.description)
        expect(JSON.parse(response.body).first.last.last['selling_price']).to eq(@tender_winner.selling_price)
        expect(JSON.parse(response.body).first.last.last['deec_no']).to eq(@stone.deec_no)
        expect(JSON.parse(response.body).first.last.last['lot_no']).to eq(@stone.lot_no)
        expect(JSON.parse(response.body).first.last.last['weight']).to eq(@stone.weight)
      end
    end

    context 'when user access tender_winners if tender winner is found' do
      it 'does match the status 200' do
        get :tender_winners, params: {tender_id: @tender.id}
        expect(JSON.parse(response.body)['response_code']).to eq(200)
      end
    end
  end

  describe '#tender_parcel' do
    context 'when user access tender_parcel if stone not found' do
      it 'does match the status 200' do
        get :tender_parcel
        expect(JSON.parse(response.body)['response_code']).to eq(200)
      end
    end

    context 'when user access tender_parcel if stone is found' do
      it 'does match the record' do
        get :tender_parcel, params: {tender_id: @tender.id}
        expect(JSON.parse(response.body)['tender_parcels'].first['stone_type']).to eq(@stone.stone_type)
        expect(JSON.parse(response.body)['tender_parcels'].first['no_of_stones']).to eq(@stone.no_of_stones)
        expect(JSON.parse(response.body)['tender_parcels'].first['weight']).to eq(@stone.weight)
        expect(JSON.parse(response.body)['tender_parcels'].first['deec_no']).to eq(@stone.deec_no)
        expect(JSON.parse(response.body)['response_code']).to eq(200)
      end
    end


    # context 'when user access tender_parcel if stone is found' do
    #   it 'does match the historical_winning record' do
    #     @supplier_mine = create(:supplier_mine, supplier:@supplier)
    #     @tender = create(:tender, supplier: @supplier, supplier_mine_id:@supplier_mine.id, open_date: DateTime.now - 20, close_date: DateTime.now - 19)
    #     @customer_tender= create(:customers_tender,  tender_id:@tender.id, customer_id:@customer.id )
    #     @stone = create(:stone, tender_id: @tender.id)
    #     @stone_rating = create(:stone_rating, stone_id:@stone.id)
    #     @tender_winner = create(:tender_winner, tender: @tender, description:@stone.description)
    #
    #
    #
    #     get :tender_parcel, params: {tender_id: @tender.id}
    #     expect(JSON.parse(response.body)['tender_parcels'].first['winners_data']["tender_id"]).to eq(@tender_winner.tender_id)
    #
    #
    #   end
    # end
    context 'when user access tender_parcel if stone is found' do
      it 'does match stone_rating comment and valuation' do
        @stone = create(:stone, tender_id: @tender.id)
        @stone_rating = create(:stone_rating, stone: @stone)
        get :tender_parcel, params: {tender_id: @tender.id}
        expect(JSON.parse(response.body)['tender_parcels'].first['comments']).to eq(@stone.comments)
        expect(JSON.parse(response.body)['tender_parcels'].first['valuation']).to eq(@stone.valuation)

      end
    end


  end


  describe '#find_active_parcels' do


    context 'when user access find_active_parcels api' do
      it 'does show  the invalid params when  params are invalid' do
        get :find_active_parcels, params: {tender_id: nil}
        response.body.should have_content('Invalid Parameters')

      end
    end
    context 'when user access find_active_parcels api' do
      it 'does match the record' do
        @tender = create(:tender, supplier: @supplier, open_date: DateTime.now - 1, close_date: DateTime.now + 2)
        @stone = create(:stone, tender: @tender)
        @stone_rating = create(:stone_rating, stone: @stone)

        get :find_active_parcels, params: {term: @stone.weight}
        expect(JSON.parse(response.body)["parcels"].first["description"]).to eq(@stone.description)
        expect(JSON.parse(response.body)["parcels"].first["stone_type"]).to eq(@stone.stone_type)
        expect(JSON.parse(response.body)["parcels"].first["no_of_stones"]).to eq(@stone.no_of_stones)
        expect(JSON.parse(response.body)["parcels"].first["size"]).to eq(@stone.size)
        expect(JSON.parse(response.body)["parcels"].first["weight"]).to eq(@stone.weight)
        expect(JSON.parse(response.body)["parcels"].first["purity"]).to eq(@stone.purity)
        expect(JSON.parse(response.body)["parcels"].first["color"]).to eq(@stone.color)
        expect(JSON.parse(response.body)["parcels"].first["polished"]).to eq(@stone.polished)
        expect(JSON.parse(response.body)["parcels"].first["deec_no"]).to eq(@stone.deec_no)
        expect(JSON.parse(response.body)["parcels"].first["lot_no"]).to eq(@stone.lot_no)
        expect(JSON.parse(response.body)["parcels"].first['comments']).to eq(@stone.comments)
        expect(JSON.parse(response.body)["parcels"].first['valuation']).to eq(@stone.valuation)
        expect(JSON.parse(response.body)["parcels"].first['parcel_rating']).to eq(@stone.parcel_rating)
      end

    end
  end
end




