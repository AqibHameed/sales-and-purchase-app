FactoryBot.define do
  factory :message do
    message {Faker::Lorem.sentence}
    message_type {"Proposal"}
    subject {Faker::Lorem.sentence}
    proposal
  end
end


