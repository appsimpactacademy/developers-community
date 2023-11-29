# frozen_string_literal: true

FactoryBot.define do
  factory :share do
    association :post, factory: :post
    association :sender, factory: :user
    association :recipient, factory: :user
  end
end
