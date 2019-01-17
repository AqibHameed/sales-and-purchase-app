FactoryBot.define do
  factory :supplier do
    name {FFaker::Name.name}
    address { FFaker::Address.address}
  end
end