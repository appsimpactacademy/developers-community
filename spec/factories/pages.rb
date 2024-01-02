FactoryBot.define do
  factory :page do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    industry { Faker::Company.industry }
    website { Faker::Internet.url }
    organization_size { %w[Small Medium Large].sample }
    organization_type { %w[Public Private Nonprofit].sample }
    association :user

    about { Faker::Lorem.paragraph }

    trait :with_user do
      association :user
    end
  end
end
