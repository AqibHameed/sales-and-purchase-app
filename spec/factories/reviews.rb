FactoryBot.define do
  factory :review do
    know { true }
    trade { false }
    recommend { true }
    experience { false }
    company
    customer
  end
end
