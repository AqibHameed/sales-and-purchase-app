require 'rails_helper'
RSpec.describe Api::V1::CompaniesController do
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
  describe '#live_monitering' do
    context 'when secure center already exists' do
      it 'does fetch secure center data' do
        Transaction.create!(buyer_id: @buyer.company_id, seller_id: @customer.company_id, trading_parcel_id: 1, due_date: 15.days.ago, created_at: 10.days.ago)
        get 'live_monitoring', params: {id: @buyer.company_id}
        expect(@secure_center).should equal?(seller_id: @customer.company_id,
                                             buyer_id: @buyer.company_id)
        expect(response.status).to eq(200)
      end
    end

    context 'when secure center not already exists' do
      it 'does create secure center and return secure center data' do
        get 'live_monitoring', params: {id: @buyer.company_id}
        expect(@secure_center).should equal?(seller_id: @customer.company_id,
                                             buyer_id: @buyer.company_id)
        expect(response.status).to eq(200)
      end
    end
  end
end