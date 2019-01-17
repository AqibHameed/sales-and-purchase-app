FactoryBot.define do
  factory :customer do
    first_name {"Gemini" + rand(1...1000).to_s}
    last_name {FFaker::Name.last_name}
    email {FFaker::Internet.email}
    password {FFaker::DizzleIpsum.words(4).join('!').first(8)}
    mobile_no {Faker::PhoneNuzmber.phone_number}
    role {Role::TRADER}
    confirmed_at {Time.now}
    company

    after(:build) do |customer|
      create(:customer_role, customer: customer)
    end

  end
end


