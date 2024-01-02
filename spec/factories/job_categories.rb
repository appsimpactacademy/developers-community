FactoryBot.define do
  factory :job_category do
    name { Faker::Job.field }

    trait :with_jobs do
      transient do
        jobs_count { 5 }
      end

      after(:create) do |job_category, evaluator|
        create_list(:job, evaluator.jobs_count, job_category: job_category)
      end
    end
  end
end
