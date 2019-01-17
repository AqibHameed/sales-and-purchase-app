FactoryBot.define do
  factory :tender do
    name {Faker::Name.name}
    open_date {DateTime.now}
    close_date {DateTime.now + 1}
    round_duration {3}
    rounds_between_duration {3}
    bid_open {DateTime.now}
    tender_type {"Blind"}
    diamond_type {"Rough"}
    country {Faker::Address.country}
    supplier

  end
end
