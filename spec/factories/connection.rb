# frozen_string_literal: true

FactoryBot.define do
  factory :connection do
    user
    connected_user_id { nil } # You can customize this value as needed
    status { 'pending' } # Set the default status as needed
  end
end
