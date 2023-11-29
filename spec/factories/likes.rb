# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    association :user
    association :post
    created_at { Time.current }
    updated_at { Time.current }
  end
end
