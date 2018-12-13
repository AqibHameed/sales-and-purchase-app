require 'rails_helper'
include LiveMonitor

describe LiveMonitor do

  before(:all) do
    seller_company = Company.create(name: Faker::Name.name)
    buyer_company = Company.create(name: Faker::Name.name)
    @customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: seller_company, authentication_token: Devise.friendly_token)
    @buyer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: buyer_company, authentication_token: Devise.friendly_token)
    create(:customer_role, customer: @customer)
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
  end
  before(:each) do
    @transaction = Transaction.create!(buyer_id: @buyer.company_id, seller_id: @customer.company_id, trading_parcel_id: 1, due_date: 15.days.ago, created_at: 10.days.ago)
  end
  describe '#update_secure_center' do
    context 'when call secure center' do
      it 'does show secure center' do
        Transaction.last.update_secure_center
      end
    end

  end
end