require 'rails_helper'
RSpec.describe Api::V1::DemandsController do
  before(:all) do

    @customer = create_customer
    @buyer = create_buyer
    @parcel = create_parcel(@customer)
    sources = ['DTC', 'RUSSIAN', 'OUTSIDE', 'SPECIAL', 'POLISHED']
    sources.each do |source|
      create_sources(source, @customer, @buyer)
    end
  end

  before(:each) do
    request.headers.merge!(authorization: @buyer.authentication_token)
  end

  describe '#index' do
    context 'when unauthorized user fetch all demands' do
      it 'does show unauthorized user' do
        request.headers.merge!(authorization: 'sadasdasdasdsadsad')
        get :index
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user fetch all demands if not exist any' do
      it 'does show demand empty' do
        get :index, params: {format: :json}
        total_demands = assigns(:all_demands).size
        expect(total_demands).to eq(5)
      end
    end
  end

  describe '#create' do
    context 'when unauthorized user want to create demand' do
      it 'does show user unauthorized' do
        request.headers.merge!(authorization: 'wetasdetoken')
        source = DemandSupplier.first
        post :create, params: {
            demand_supplier_id: source.id,
            description: [
                source.demand_list.first.description
            ]
        }
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user want to create demand' do
      it 'does create demand' do
        source = DemandSupplier.first
        post :create, params: {
            demand_supplier_id: source.id,
            description: [
                source.demand_list.first.description
            ]
        }
        response.body.should have_content('Demand created successfully')
      end
    end
  end

  describe '#destroy' do
    context 'when unauthorized user try to delete demand' do
      it 'does show message unauthorized user' do
        request.headers.merge!(authorization: 'sdadasdasdasdsd')
        demand = Demand.last
        get :destroy, params: {id: demand.id}
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user try to delete demand' do
      it 'does show message demand deleted successfully' do
        demand = Demand.last
        get :destroy, params: {id: demand.id}
        response.body.should have_content('Demand destroy successfully')
      end
    end

    context 'when authorized user try to delete unknown demand' do
      it 'does show message demand not exist' do
        get :destroy, params: {id: 22}
        response.body.should have_content('Demand does not exist')
      end
    end

  end

  describe '#demand_supplier'do
    context 'when any user want to get sources' do
      it 'does show all resources' do
        get :demand_suppliers
        response.body.should have_content('DTC')
        response.body.should have_content('RUSSIAN')
        response.body.should have_content('OUTSIDE')
        response.body.should have_content('SPECIAL')
        response.body.should have_content('POLISHED')
      end
    end
  end

  describe '#demand_description'do
    context 'when user want to see demand descriptions'do
      it 'does show all description related to demand' do
        source = DemandSupplier.last
        get :demand_description, params: {demand_supplier_id: source.id}
        response.body.should have_content('POLISHED')
        response.body.should have_content(source.demand_list.last.description)
      end
    end
  end

  describe '#parcels_list' do
    context 'when unauthorized user want to see list of parcels'do
      it 'does show error unauthorized' do
        request.headers.merge!(authorization: 'sdadauabdjbash')
        get :parcels_list
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user want to see list of parcels'do
      it 'does show all parcels' do
        get :parcels_list
      end
    end
  end
end