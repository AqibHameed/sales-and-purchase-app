require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  before(:all) do
    create_user
  end

  context 'Sign in User ' do
    scenario 'should be successful' do
      login_user
    end
  end

  def create_user
    company = Company.create(name: Faker::Name.name)
    @customer = Customer.create(first_name: 'mister', last_name: 'padana', email: 'aqibpadana@gmail.com',
                                password: '123123123', mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.now, company: company)
    create(:customer_role, customer: @customer)
  end

  def login_user
    visit new_customer_session_path
    within('#new_customer') do
      fill_in 'customer_login', with: @customer.email
      fill_in 'customer_password', with: '123123123'
      click_button('Login')
      visit trading_customers_path
    end
  end
end
