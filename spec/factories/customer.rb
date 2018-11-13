FactoryBot.define do
  factory :customer do
    first_name { "Gemini" + ('a'..'z').to_a.shuffle.join }
    last_name FFaker::Name.last_name
    email FFaker::Internet.email
    password  FFaker::DizzleIpsum.words(4).join('!').first(8)
    mobile_no Faker::PhoneNumber.phone_number
    role   "Buyer/Seller"
    confirmed_at          Time.now
    company

    after(:build) do |customer|
      create(:customer_role, customer: customer)
    end

  end
end


