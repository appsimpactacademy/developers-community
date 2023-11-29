# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:user) { create(:user) }
  let(:job) { create(:job) }
  let(:job_category) { create(:job_category) }

  it 'belongs to a job_category' do
    job = create(:job, job_category:)
    expect(job.job_category).to eq(job_category)
  end

  it 'belongs to a user' do
    job = create(:job, user:)
    expect(job.user).to eq(user)
  end

  it 'validates EMPLOYEE_TYPE values' do
    expect(Job::EMPLOYEE_TYPE).to include(job.employee_type)
  end

  it 'validates STATUS values' do
    expect(Job::STATUS).to include(job.status)
  end

  it 'validates SALARY values' do
    expect(Job::SALARY).to include(job.salary)
  end

  it 'validates QUALIFICATION values' do
    expect(Job::QUALIFICATION).to include(job.qualification)
  end

  it 'defines ransackable attributes' do
    ransackable_attributes = Job.ransackable_attributes
    expect(ransackable_attributes).to include(
      'created_at', 'description', 'employee_type', 'id', 'job_category_id', 'location', 'qualification', 'salary', 'status', 'title', 'updated_at', 'user_id'
    )
  end

  it 'defines ransackable associations' do
    ransackable_associations = Job.ransackable_associations
    expect(ransackable_associations).to include('job_category', 'user')
  end
end
