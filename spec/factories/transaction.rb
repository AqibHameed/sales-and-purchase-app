FactoryBot.define do
  factory :transaction do
    buyer_confirmed {true}
    created_at {DateTime.now}
    trading_parcel
  end
end


