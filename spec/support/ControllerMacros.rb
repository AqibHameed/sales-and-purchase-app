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

  def create_permission_request(permission)
    create(:premission_request, permission)
  end

  def create_buyer
   company = Company.create(name: Faker::Name.name)
   buyer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                      password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                      role: Role::BUYER, confirmed_at: Time.current, company: company, authentication_token: Devise.friendly_token)
   role = Role.find_by(name: 'Buyer')
   create(:customer_role, customer: buyer, role: role)
    buyer
  end

  def buyer_create_proposal(buyer)
       create(:proposal, buyer_id: buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
  end

  def create_message(buyer, proposal)
      create(:message, sender_id: buyer.company.id, receiver_id: @customer.company.id, proposal: proposal)
  end

  def create_parcel(customer)
    create(:trading_parcel, customer: customer, company: customer.company)
  end

  def create_broker
    company = Company.create(name: Faker::Name.name)
    broker = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                               password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                               role: Role::BROKER, confirmed_at: Time.current, company: company, authentication_token: Devise.friendly_token)
    role = Role.find_by(name: 'Broker')
    create(:customer_role, customer: broker, role: role)
    broker
  end

  def create_customer
    company = Company.create(name: Faker::Name.name)
    customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                    password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                    role: Role::TRADER, confirmed_at: Time.current, company: company, authentication_token: Devise.friendly_token)
    role = Role.find_by(name: 'Trader')
    create(:customer_role, customer: customer)
    customer
  end

  def create_roles
    roles = [Role::BUYER, Role::BROKER, Role::TRADER, Role::SUPPLIER]
    roles.each do |role|
      create(:role, name: role)
    end
  end


  def create_review(buyer_id, company_id)
    create(:review, customer_id: buyer_id, company_id: company_id)
    Rank.update_rank
  end

  def create_sources(source, seller, buyer)
    created_source = create(:demand_supplier, name: source)

    create(:demand_list,
           description: "#{Faker::Lorem.sentence} #{source}",
           demand_supplier_id: created_source.id)

    create(:trading_parcel, customer: buyer,
           company: buyer.company,
           description: created_source.demand_list.first.description,
           source: created_source.name)

    create(:demand, company_id: buyer.company_id,
           demand_supplier_id: created_source.id,
           description: created_source.demand_list.first.description)
  end

  def create_transaction(buyer, customer, parcel)
    create(:transaction, buyer_id: buyer.company_id,
           seller_id: customer.company_id,
           trading_parcel_id: parcel.id,
           diamond_type: 'Rough')
  end

end
