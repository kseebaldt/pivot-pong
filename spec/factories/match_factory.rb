FactoryGirl.define do
  factory :match do
    association :winner, factory: :player
    association :loser, factory: :player
    occurred_at { 10.minutes.ago }
  end
end