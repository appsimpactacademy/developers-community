FactoryBot.define do
  factory :skill do
    title { Faker::Lorem.word }
    association :user, factory: :user
  end
end