FactoryBot.define do
  factory :stone do
    stone_type {'Stone'}
    no_of_stones {3}
    weight {28}
    deec_no {1}
    lot_no {1}
    description {Faker::Lorem.sentence}
    status {'unsold'}
    tender
  end
end

