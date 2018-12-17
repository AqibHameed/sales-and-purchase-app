FactoryBot.define do
  factory :transaction do
    due_date {Date.current + 30}
    created_at {10.days.ago}
    buyer_confirmed {true}
    paid {false}
  end
end


