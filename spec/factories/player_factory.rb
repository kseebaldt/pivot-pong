FactoryGirl.define do
  factory :player do
    sequence(:name) { |n| "Player #{n}-bob"}
  end
end