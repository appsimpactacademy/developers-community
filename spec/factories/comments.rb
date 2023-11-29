# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    commentable_type { 'Post' }
    association :commentable, factory: :post
    title { Faker::Lorem.sentence }
    association :user
  end
end
