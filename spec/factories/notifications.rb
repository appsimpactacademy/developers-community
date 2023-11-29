# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    item_type { 'User' }
    item_id { nil }
    association :user, factory: :user
    viewed { false }
  end
end
