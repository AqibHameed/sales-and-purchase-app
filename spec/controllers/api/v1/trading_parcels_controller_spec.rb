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
        expect(response.status).to eq(200)
        expect(response.message).to eq("OK")
        expect(response.success?).to eq(true)
      end
    end
  end
end