module ControllerMacros

  def create_user
    @customer = create(:customer)
  end

  def login_user(customer = nil)
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer, scope: :customer
    customer
  end

  def create_user_login_user
    #create_user
    login_user @customer
  end

  def create_buyer
   company = Company.create(name: Faker::Name.name)
   buyer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                      password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                      role: "Buyer/Seller", confirmed_at: Time.current, company: company, authentication_token: Devise.friendly_token)
    create(:customer_role, customer: buyer)
    buyer
  end

  def buyer_create_proposal(buyer)
       create(:proposal, buyer_id: buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
  end

  def create_message(buyer, proposal)
      create(:message, sender_id: buyer.company.id, receiver_id: @customer.company.id, proposal: proposal)
  end

end
