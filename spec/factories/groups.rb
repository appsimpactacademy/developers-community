FactoryBot.define do
  factory :group do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    industry { Faker::Company.industry }
    location { Faker::Address.city }
    group_type { %w[Public Private].sample }
    association :user

    # Other attributes can be added based on your requirements

    trait :public_group do
      group_type { 'Public' }
    end

    trait :private_group do
      group_type { 'Private' }
    end
  end
end
