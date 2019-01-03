require 'rails_helper'
RSpec.describe Api::V1::LimitsController do
  before(:all) do
    @company = Company.create(name: Faker::Name.name)
    @customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: @company, authentication_token: Devise.friendly_token)
    create(:customer_role, customer: @customer)
    create(:credit_limit, buyer_id: @company.id, seller_id: @customer.id)
    create(:days_limit, buyer_id: @company.id, seller_id: @customer.id)
  end

  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
  end

  describe '#add_limits' do
    context 'when unauthorized user to update the credit limit' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'wetasdetoken')
        post :add_limits
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user to update the credit limit and buyer id is not exist' do
      it 'does show the message Buyer doesnt exist' do
        post :add_limits, params: {buyer_id: 'al'}
        response.body.should have_content("Buyer doesn't exist")
      end
    end

    context 'when authorized user to update the credit limit and buyer id is  exist' do
      it 'does show the message Limits updated' do
        post :add_limits, params: {buyer_id: @company.id, limit: '3000'}
        response.body.should have_content("Limits updated")
      end
    end
  end

  describe '#add_overdue_limit' do
    context 'when unauthorized user to update the days limit' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'wetasdetoken')
        post :add_overdue_limit
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user to update the days limit and buyer id is not exist' do
      it 'does show the message Buyer doesnt exist' do
        post :add_overdue_limit, params: {buyer_id: 'al'}
        response.body.should have_content("Buyer doesn't exist")
      end
    end

    context 'when authorized user to update the days limit and buyer id is  exist' do
      it 'does show the message Days Limit updated' do
        post :add_overdue_limit, params: {buyer_id: @company.id, limit: '20'}
        response.body.should have_content("Days Limit updated")
      end
    end
  end
end