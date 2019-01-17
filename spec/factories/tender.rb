FactoryBot.define do
  factory :tender do
    name {"roadTender"}
    open_date {2019-01-20}
    close_date{2019-01-30}
    supplier_id {1}
    round_duration{3}
    rounds_between_duration{3}
    bid_open{2019-01-20}
    tender_type{"yes/no"}
    diamond_type{"rough"}

  end
end
