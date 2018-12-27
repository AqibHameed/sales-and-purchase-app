require 'rails_helper'
RSpec.describe Api::V1::RegistrationsController do
  before(:each) do
      @company = create(:company, is_broker: true)
      @customer = create(:customer, company: @company)
  end
  describe '#create' do
    context 'when company status Individual and role is broker then' do
      it 'does compnay exist' do
        post :create, params: { registration: {
                                 company_individual: 'Individual',
                                 role: 'Broker',
                                 first_name: FFaker::Name.first_name,
                                 last_name: FFaker::Name.last_name,
                                 email: FFaker::Internet.email,
                                 password: FFaker::DizzleIpsum.words(4).join('!').first(8),
                                 country_code: '+92',
                                 mobile_no: Faker::PhoneNumber.phone_number
                               }
        }
        expect(assigns[:company]).to be_present
      end

    end

    context 'when role is broker and company customer exist' do
      it 'does not create a customer' do
        post :create, params: { registration: {
            company_individual: 'Individual',
            role: 'Broker',
            first_name: FFaker::Name.first_name,
            last_name: FFaker::Name.last_name,
            email: FFaker::Internet.email,
            password: FFaker::DizzleIpsum.words(4).join('!').first(8),
            country_code: '+92',
            mobile_no: Faker::PhoneNumber.phone_number,
            company_id: @company.id
          }
        }
        response.body.should have_content('Company already registered as buyer/seller')
      end
    end

    context 'when role is blank' do
      it 'does not create a customer' do
        post :create, params: { registration: {
            company_individual: 'Individual',
            role: '',
            first_name: FFaker::Name.first_name,
            last_name: FFaker::Name.last_name,
            email: FFaker::Internet.email,
            password: FFaker::DizzleIpsum.words(4).join('!').first(8),
            country_code: '+92',
            mobile_no: Faker::PhoneNumber.phone_number,
            company_id: @company.id
        }
        }
        response.body.should have_content("Role can't be blank")
      end
    end

    context 'when role is Buyer/Seller and company customer exist' do
      it 'does not create a customer' do
        post :create, params: { registration: {
            company_individual: 'Individual',
            role: 'Buyer/Seller',
            first_name: FFaker::Name.first_name,
            last_name: FFaker::Name.last_name,
            email: FFaker::Internet.email,
            password: FFaker::DizzleIpsum.words(4).join('!').first(8),
            country_code: '+92',
            mobile_no: Faker::PhoneNumber.phone_number,
            company_id: @company.id
        }
        }
        response.body.should have_content("already registered as broker")
      end
    end

    context 'when role is Buyer/Seller and company customer exist' do
      it 'does not create a customer' do
        post :create, params: { registration: {
            company_individual: 'Individual',
            role: 'Broker',
            first_name: FFaker::Name.first_name,
            last_name: FFaker::Name.last_name,
            email: FFaker::Internet.email,
            password: FFaker::DizzleIpsum.words(4).join('!').first(8),
            country_code: '+92',
            mobile_no: Faker::PhoneNumber.phone_number
        }
        }
        response.body.should have_content("An email has been sent to your email. Please verify the email")
        expect(JSON.parse(response.body)['customer']['id']).to be_present
        expect(JSON.parse(response.body)['customer']['email']).to be_present
        expect(JSON.parse(response.body)['customer']['first_name']).to be_present
        expect(JSON.parse(response.body)['customer']['mobile_no']).to be_present
        expect(JSON.parse(response.body)['customer']['authentication_token']).to be_present
        response.success?.should be true
      end
    end

    context 'when email is confirmed' do
      it 'does exist the customer record' do
        post :create, params: { registration: {
            company_individual: 'Individual',
            role: 'Broker',
            first_name: FFaker::Name.first_name,
            last_name: FFaker::Name.last_name,
            email: FFaker::Internet.email,
            password: FFaker::DizzleIpsum.words(4).join('!').first(8),
            country_code: '+92',
            mobile_no: Faker::PhoneNumber.phone_number,
            confirmed_at: Time.now
        }
        }
        expect(JSON.parse(response.body)['customer']['id']).to be_present
        expect(JSON.parse(response.body)['customer']['email']).to be_present
        expect(JSON.parse(response.body)['customer']['first_name']).to be_present
        expect(JSON.parse(response.body)['customer']['mobile_no']).to be_present
        expect(JSON.parse(response.body)['customer']['authentication_token']).to be_present
        response.success?.should be true
      end
    end

    context 'when email is confirmed and is_requested is true' do
      it 'does not create a customer' do
        post :create, params: { registration: {
            company_individual: 'Individual',
            role: 'Broker',
            first_name: FFaker::Name.first_name,
            last_name: FFaker::Name.last_name,
            email: FFaker::Internet.email,
            password: FFaker::DizzleIpsum.words(4).join('!').first(8),
            country_code: '+92',
            mobile_no: Faker::PhoneNumber.phone_number,
            confirmed_at: Time.now,
            is_requested: true

        }
        }
        response.body.should have_content("A request has been to sent to your company admin for approval. You can access your account after approval")
        expect(JSON.parse(response.body)['customer']['id']).to be_present
        expect(JSON.parse(response.body)['customer']['email']).to be_present
        expect(JSON.parse(response.body)['customer']['first_name']).to be_present
        expect(JSON.parse(response.body)['customer']['mobile_no']).to be_present
        expect(JSON.parse(response.body)['customer']['authentication_token']).to be_present
        response.success?.should be true
      end
    end

  end

end