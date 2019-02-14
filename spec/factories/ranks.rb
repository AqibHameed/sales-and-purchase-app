FactoryBot.define do
  factory :rank do
    company { nil }
    yes_know { 1 }
    not_know { 1 }
    yes_trade { 1 }
    not_trade { 1 }
    yes_recommend { 1 }
    not_recommend { 1 }
    yes_experience { 1 }
    not_experience { 1 }
    total_know { 1.5 }
    total_trade { 1.5 }
    total_recommend { 1.5 }
    total_experience { 1.5 }
    total_average { 1.5 }
    rank { "MyString" }
  end
end
