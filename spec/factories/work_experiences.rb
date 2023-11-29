# frozen_string_literal: true

FactoryBot.define do
  factory :work_experience do
    start_date { Date.today - 2.years }
    end_date { Date.today }
    job_title { 'Software Engineer' }
    employment_type { 'Full-time' }
    location { 'New York, NY' }
    location_type { 'On-site' }
    currently_working_here { false }
    description { 'Worked on various software projects.' }
    company { 'ABC Corporation' }

    # Assuming you have a user association
    association :user, factory: :user
  end
end
