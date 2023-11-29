# frozen_string_literal: true

FactoryBot.define do
  factory :follow do
    # Assuming you have a user association
    association :user, factory: :user

    followed_type { 'User' } # Adjust the type as needed (e.g., 'Page' if applicable)
    association :followed, factory: :user # Replace with the appropriate factory for the followed model
  end
end
