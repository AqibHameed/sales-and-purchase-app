FactoryBot.define do
  factory :company do
    name {Faker::Name.name}
    county {Faker::Address.country}
  end
end


