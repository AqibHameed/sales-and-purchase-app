require 'rails_helper'
RSpec.describe Api::V1::TendersController do
  before(:all) do
    # create_roles
    @supplier = create(:supplier)
    # @tender = create_tender
    @tender = create(:tender, supplier: @supplier, open_date: DateTime.now - 1, close_date: DateTime.now + 2)
    @tender = create(:tender, supplier: @supplier, open_date: DateTime.now + 1, close_date: DateTime.now + 2)
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
        tender = create(:tender, supplier: @supplier, open_date: DateTime.now + 1, close_date: DateTime.now + 2)
        get :index
        expect(JSON.parse(response.body)['tenders'].last['start_date'].to_datetime).to be > DateTime.now
      end
    end

    context 'when authorized  tender access the api' do
      it 'does show the past tenders' do
        tender = create(:tender, supplier: @supplier, open_date: DateTime.now - 2, close_date: DateTime.now - 1)
        get :index
        expect(JSON.parse(response.body)['tenders'].first['end_date'].to_datetime).to be < DateTime.now
      end
    end

  end






  describe '#tender_upcomming' do
    context 'when authorized  tender access the api' do
      it 'does show the upcoming tenders' do
        get :index
        expect(JSON.parse(response.body)['tenders'].last['start_date'].to_datetime).to be > DateTime.now
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
end




