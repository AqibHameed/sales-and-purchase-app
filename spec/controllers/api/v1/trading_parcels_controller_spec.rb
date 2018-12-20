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
                                                cost: 2500.0,
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
                                                                cost: 2500.0,
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

  describe '#direct_sell' do
    context 'when seller do direct_sell' do
      it 'does sold successfully' do
        post :direct_sell, params: {trading_parcel:
                                        {
                                            diamond_type: "Sight",
                                            source: "RUSSIAN",
                                            box_value: "34",
                                            sight: "11/18",
                                            lot_no: "",
                                            description: "+11 SAWABLES LIGHT",
                                            no_of_stones: "34",
                                            cost: "34",
                                            percent: "34.00",
                                            shape: "",
                                            color: "",
                                            clarity: "",
                                            cut: "",
                                            polish: "",
                                            symmetry: "",
                                            fluorescence: "",
                                            lab: "",
                                            city: "",
                                            country: "AF",
                                            credit_period: "34",
                                            customer_id: "21",
                                            company_id: "8",
                                            weight: "34",
                                            price: "45.56",
                                            total_value: "1549.04",
                                            comment: "",
                                            sale_broker: "0",
                                            sale_demanded: "1",
                                            broker_ids: "",
                                            my_transaction_attributes:
                                                {
                                                    seller_id: @customer.company_id,
                                                    transaction_type: "manual",
                                                    buyer_confirmed: "false",
                                                    buyer_id: "7",
                                                    created_at: "28/12/2018",
                                                    paid: "0"
                                                }
                                        }
        }
      end
    end
  end
end