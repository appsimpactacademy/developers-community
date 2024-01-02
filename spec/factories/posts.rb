FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    hidden { false }

    # Associations
    association :user
    association :page
    association :group
  end
end
