require 'rails_helper'
RSpec.describe Api::V1::TradingParcelsController do
  before(:all) do
    company = Company.create(name: Faker::Name.name)
    @customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: company, authentication_token: Devise.friendly_token)
    create(:customer_role, customer: @customer)
    @buyer = create_buyer
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
  end

  before(:each) do
  end

  describe '#create trading parcel' do
    context 'when seller create trading parcel' do
      it 'does create parcel' do
        post :create, params: {trading_parcel: {source: 'SPECIAL',
                                                description: '5-10 Cts BLK CLIV WHITE',
                                                credit_period: '2000',
                                                no_of_stones: '10',
                                                total_value: 5000.0,
                                                percent: '10',
                                                cost:  2500.0,
                                                avg_price: 2000.0,
                                                carats: 1,
                                                comment: '',
                                                discout: '',
                                                sight: '',
                                                lot_no: ''}}
        response.body.should have_content('Parcel created successfully')
        expect(response.status).to eq(200)
        expect(response.message).to eq("OK")
        expect(response.success?).to eq(true)
      end
    end
  end

  describe '#update' do
    context 'when seller update trading parcel' do
      it 'does update the related parcel' do
        post :update, params: {id: @parcel.id, trading_parcel: {source: 'SPECIAL',
                                                description: '5-10 Cts BLK CLIV WHITE',
                                                credit_period: '2000',
                                                no_of_stones: '10',
                                                total_value: 5000.0,
                                                percent: '10',
                                                cost:  2500.0,
                                                avg_price: 2000.0,
                                                carats: 1,
                                                comment: '',
                                                discout: '',
                                                sight: '',
                                                lot_no: ''}}
        response.body.should have_content('Parcel updated successfully')
        expect(response.status).to eq(200)
        expect(response.message).to eq("OK")
        expect(response.success?).to eq(true)
      end
    end
  end

  describe '#show' do
    context 'when seller want to see any single trading parcel' do
      it 'does show the related parcel' do
        get :show, params: {id: @parcel.id}
        response.body.should have_content(@parcel.id)
        expect(response.status).to eq(200)
        expect(response.message).to eq("OK")
        expect(response.success?).to eq(true)
      end
    end
  end
end