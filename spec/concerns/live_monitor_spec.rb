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
    @parcel1 = create(:trading_parcel, customer: @customer, company: @customer.company)
  end
  # before(:each) do
  #
  # end
  describe '#update_secure_center' do
    context 'when call secure center' do
      it 'does show paid date equal to nil' do
        transaction = Transaction.create!(buyer_id: @buyer.company_id,
                                           seller_id: @customer.company_id,
                                           trading_parcel_id: @parcel1.id,
                                           due_date: 15.days.ago,
                                           created_at: 10.days.ago,
                                           price: 100,
                                           buyer_confirmed: true,
                                           remaining_amount: 200)
        transactions = transaction.secure_center
        transactions.last.paid_date.should be nil
      end
    end
    context 'when transaction paid' do
      it 'does show the last paid date' do
        transaction = Transaction.create!(buyer_id: @buyer.company_id,
                                          seller_id: @customer.company_id,
                                          trading_parcel_id: @parcel1.id,
                                          due_date: 15.days.ago,
                                          created_at: 10.days.ago,
                                          price: 100,
                                          buyer_confirmed: true,
                                          remaining_amount: 0,
                                          paid: false)
        partial = PartialPayment.create(company_id: @buyer.company_id, transaction_id: transaction.id, amount: 50,)
        transactions = transaction.secure_center
        expect(Date.current).to eq(transactions.last.paid_date)
      end
    end
  end
end