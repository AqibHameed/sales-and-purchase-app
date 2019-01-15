FactoryBot.define do
  factory :feedback do
    star { 1 }
    comment { "MyText" }
    demand_id { 1 }
    trading_parcel { 1 }
    partial_payment { 1 }
    proposal_id { 1 }
    credit_limit { 1 }
    customer_id { 1 }
  end
end
