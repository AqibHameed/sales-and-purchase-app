require 'rails_helper'
RSpec.describe Api::V1::ProposalsController do
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

  describe '#create' do
    context 'when user submite proposal without authorization' do
      it 'does show error un authorized user' do
        post :create, params: {
            trading_parcel_id: @parcel.id,
            credit: 155,
            price: 4500,
            total_value: 4000
        }
        response.body.should have_content('Not authenticated')
        request.headers.merge!(authorization: @customer.authentication_token)
      end
    end

    context 'when user submite proposal with authorized user' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: @customer.authentication_token)
        post :create, params: {
            trading_parcel_id: '',
            credit: 155,
            price: 4500,
            total_value: 4000
        }
        response.body.should have_content('Parcel does not exists for this id')
      end

      it 'does submite proposal succesfully' do
        request.headers.merge!(authorization: @customer.authentication_token)
        post :create, params: {
            trading_parcel_id: @parcel.id,
            credit: 155,
            price: 4500,
            total_value: 4000
        }
        response.body.should have_content('Proposal Submitted Successfully')
      end
    end

    context 'when update proposal with proposal id'do
      it 'does update exiting proposal' do
        create(:proposal, buyer_id: @buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
        proposal = Proposal.last
        request.headers.merge!(authorization: @customer.authentication_token)
        post :create, params: {
            id: proposal.id,
            credit: 155,
            price: 4500,
            total_value: 4000
        }
        response.body.should have_content('Proposal Updated Successfully')
      end
    end
  end
  
end