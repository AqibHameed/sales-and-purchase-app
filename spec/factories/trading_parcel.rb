FactoryBot.define do
  factory :trading_parcel do
    description {Faker::Lorem.sentence}
    source {"OutSide Goods"}
    credit_period {30}
    total_value {4000.0}
    price {10.0}
    weight {10.0}
    customer
    company
  end
end

