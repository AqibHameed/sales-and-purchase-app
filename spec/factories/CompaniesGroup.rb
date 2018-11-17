FactoryBot.define do
  factory :companies_group do
    group_name {'Dummy Group'}
    group_market_limit {200}
    group_overdue_limit {300}
  end
end

