FactoryBot.define do
  factory :tender_winner do
    lot_no {1}
    selling_price {"50"}
    avg_selling_price {60.0}
    description {Faker::Lorem.sentence}
    tender
  end
end


