FactoryBot.define do
  factory :supplier_mine do
    name {Faker::Name.name}
    supplier
  end
end