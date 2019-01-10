require 'rails_helper'
RSpec.describe Api::V1::SessionsController do
  before(:all) do
    create_roles
    @customer = create_customer
  end

  describe '#create' do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:customer]
    end
    context 'When user login with wrong email address' do

      it 'does match the message Error with your login or password' do
        post :create, params: { customer: {
                                 email: 'umair@gmail.com',
                                 password: "12345678"
                               }
        }
        response.body.should have_content('Error with your login or password')
      end
    end

    context 'When user login with wrong password address' do

      it 'does match the message Error with your login or password' do
        post :create, params: { customer: {
            email: @customer.email,
            password: "12345678"
        }
        }
        response.body.should have_content('Error with your login or password')
      end
    end

    context 'When user login with correct password address' do

      it 'does match the message Please verify the email' do
        company = Company.create(name: Faker::Name.name)
        customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                   password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                   role: Role::TRADER, company: company, authentication_token: Devise.friendly_token)
        create(:customer_role, customer: customer)
        post :create, params: { customer: {
            email: customer.email,
            password: customer.password
        }
        }
        response.body.should have_content('Please verify the email')
      end
    end

    context 'When user login with correct password address' do

      it 'Company admin has not provided access' do
        company = Company.create(name: Faker::Name.name)
        customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                   password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                   role: Role::TRADER, company: company, confirmed_at: Time.current, is_requested: true, authentication_token: Devise.friendly_token)
        create(:customer_role, customer: customer)
        post :create, params: { customer: {
            email: customer.email,
            password: customer.password
        }
        }
        response.body.should have_content('Company admin has not provided access')
      end
    end

    context 'When user login with correct password address' do

      it 'does match the message Please verify the email' do
        post :create, params: { customer: {
            email: @customer.email,
            password: @customer.password
        }
        }
        expect(JSON.parse(response.body).flatten.second['email']).to eq(@customer.email)
        expect(JSON.parse(response.body).flatten.second['company']).to eq(@customer.company.name)
        expect(JSON.parse(response.body).flatten.second['mobile_no']).to eq(@customer.mobile_no)
      end
    end
  end

  describe '#customer_by_token' do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:customer]
    end
    context 'when try to find  the customer with wrong toket' do
      it 'does match the message Customer does not exist for this token' do
        request.headers.merge!(authorization: 'asdasdasdasdasdsd')
        get :customer_by_token
        response.body.should have_content('Customer does not exist for this token')
      end
    end

    context 'when try to find  the customer with correct toket' do
      it 'does match the message Customer does not exist for this token' do
        request.headers.merge!(authorization: @customer.authentication_token)
        get :customer_by_token
        expect(JSON.parse(response.body).flatten.second['email']).to eq(@customer.email)
        expect(JSON.parse(response.body).flatten.second['company']).to eq(@customer.company.name)
        expect(JSON.parse(response.body).flatten.second['mobile_no']).to eq(@customer.mobile_no)
      end
    end
  end

end