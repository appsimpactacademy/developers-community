# frozen_string_literal: true

FactoryBot.define do
  factory :job do
    title { 'Sample Job Title' }
    description { 'Sample Job Description' }
    employee_type { 'Full-time' }
    location { 'Sample Location' }
    salary { '₹ 5000-10000' }
    qualification { 'Graduation' }
    status { 'Public' }

    # Assuming you have a JobCategory and User model, and you want to associate them
    association :job_category, factory: :job_category
    association :user, factory: :user

    created_at { Time.now }
    updated_at { Time.now }
  end
end
