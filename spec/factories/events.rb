# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    event_type { 'In Person' }
    event_name { 'Sample Event' }
    start_date { Date.today }
    end_date { Date.tomorrow }
    start_time { '10.00 AM' }
    end_time { '11.00 AM' }
    description { 'Sample event description' }
    association :user, factory: :user  # Assuming you have a user factory
  end
end
