# frozen_string_literal: true

# spec/models/work_experience_spec.rb

require 'rails_helper'

RSpec.describe WorkExperience, type: :model do
  let(:user) { create(:user) } # Assuming you have a factory for User

  it 'belongs to a user' do
    work_experience = create(:work_experience, user:) # Assuming you have a factory for WorkExperience
    expect(work_experience.user).to eq(user)
  end

  it 'is valid with all required attributes' do
    work_experience = build(:work_experience, user:)
    expect(work_experience).to be_valid
  end

  it 'is not valid without a company' do
    work_experience = build(:work_experience, user:, company: nil)
    expect(work_experience).not_to be_valid
  end

  it 'is not valid without a start date' do
    work_experience = build(:work_experience, user:, start_date: nil)
    expect(work_experience).not_to be_valid
  end

  it 'is not valid without a job title' do
    work_experience = build(:work_experience, user:, job_title: nil)
    expect(work_experience).not_to be_valid
  end

  it 'is not valid without a location' do
    work_experience = build(:work_experience, user:, location: nil)
    expect(work_experience).not_to be_valid
  end

  it 'is not valid without an employment type' do
    work_experience = build(:work_experience, user:, employment_type: nil)
    expect(work_experience).not_to be_valid
  end

  it 'is not valid with an invalid employment type' do
    work_experience = build(:work_experience, user:, employment_type: 'Invalid Type')
    expect(work_experience).not_to be_valid
  end

  it 'is not valid without a location type' do
    work_experience = build(:work_experience, user:, location_type: nil)
    expect(work_experience).not_to be_valid
  end

  it 'is not valid with an invalid location type' do
    work_experience = build(:work_experience, user:, location_type: 'Invalid Type')
    expect(work_experience).not_to be_valid
  end

  it 'is not valid if end date is greater than start date' do
    work_experience = build(:work_experience, user:, start_date: Date.today, end_date: Date.yesterday)
    expect(work_experience).not_to be_valid
  end

  it 'validates presence of end date when not currently working here' do
    work_experience = build(:work_experience, user:, end_date: nil, currently_working_here: false)
    work_experience.valid?
    expect(work_experience.errors[:end_date]).to include(' must be present if you are not currently working in this company')
  end

  it 'is not valid if end date is present and currently_working_here is true' do
    work_experience = build(:work_experience, user:, start_date: Date.today, end_date: Date.tomorrow,
                                              currently_working_here: true)

    expect(work_experience).not_to be_valid
  end

  it 'is not valid if end date is missing when currently_working_here is true' do
    work_experience = build(:work_experience, user:, start_date: Date.today, currently_working_here: true)
    expect(work_experience).not_to be_valid
  end

  it 'calculates job duration correctly if end_date is present' do
    start_date = Date.new(2020, 1, 1)
    end_date = Date.new(2022, 1, 1)
    work_experience = build(:work_experience, user:, start_date:, end_date:)

    expect(work_experience.job_duration).to eq('Jan 2020 - Jan 2022 (2 years 0 month)')
  end

  it 'calculates job duration when currently working here' do
    start_date = Date.new(2020, 1, 1)
    work_experience = build(:work_experience, user:, start_date:, currently_working_here: true)
    allow(Date).to receive(:today).and_return(Date.new(2023, 5, 1)) # Stub Date.today

    expect(work_experience.job_duration).to eq('Jan 2020 - Present (3 years 10 months)')
  end

  it 'formats company with employment type' do
    work_experience = build(:work_experience, user:, company: 'ABC Inc', employment_type: 'Full-time')
    expect(work_experience.company_with_employment_type).to eq('ABC Inc (Full-time)')
  end

  it 'formats job location' do
    work_experience = build(:work_experience, user:, location: 'New York', location_type: 'On-site')
    expect(work_experience.job_location).to eq('New York (On-site)')
  end
end
