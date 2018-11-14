require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  before(:each) do
    create_user
    sign_in_user
  end

  context 'After Sign in seller ' do
    scenario 'should visit the perposal' do
      buyer = create_buyer
      proposal = buyer_create_proposal(buyer)
      message = create_message(buyer, proposal)
      visit proposal_path(proposal.id)
    end
    scenario 'should be able to read messages from inbox' do
      inbox = page.find(:xpath, "//a[contains(@href,'/messages')]")
      inbox.click
      page.find('#tenderList')
    end
  end
end

def create_user
  company = Company.create(name: Faker::Name.name)
  @customer = Customer.create(first_name: 'mister', last_name: 'padana', email: 'aqibpadana@gmail.com',
                              password: '123123123', mobile_no: Faker::PhoneNumber.phone_number,
                              role: "Buyer/Seller", confirmed_at: Time.now, company: company)
  create(:customer_role, customer: @customer)
  @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
end

def create_buyer
  company = Company.create(name: Faker::Name.name)
  buyer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                          password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                          role: "Buyer/Seller", confirmed_at: Time.now, company: company)
  create(:customer_role, customer: buyer)
  buyer
end

def buyer_create_proposal(buyer)
  create(:proposal, buyer_id: buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
end

def create_message(buyer, proposal)
  create(:message, sender_id: buyer.company.id, receiver_id: @customer.company.id, proposal: proposal)
end

def sign_in_user
  visit new_customer_session_path
  within('#new_customer') do
    fill_in 'customer_login', with: @customer.email
    fill_in 'customer_password', with: '123123123'
    click_button('Login')
    visit trading_customers_path
  end
end
