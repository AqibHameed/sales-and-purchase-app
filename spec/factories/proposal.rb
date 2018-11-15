FactoryBot.define do
  factory :proposal do
    price      3000.0
    credit     1000
    total_value {600}
    trading_parcel
  end
end


