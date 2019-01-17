FactoryBot.define do
  factory :supplier do
    name {Faker::Name.name}
    address { Faker::Address.country}
  end
end