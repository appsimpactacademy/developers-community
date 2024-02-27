# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Job', type: :feature do
  describe 'Job' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'go to job path when no job exists' do
      find('#users_job', wait: 10).click
      jobs_container = find('#job_user', wait: 10)
      expect(user.jobs.count).to eq(0)
      expect(jobs_container).to have_text('No job is present!')
    end


    it 'go to job path when job category exists' do

      job_category = create(:job_category)

      marketing_agency_page = create(:page, title: 'Marketing Agency X', user: user)
      
      visit user_my_jobs_path(user)
      
      find('#add-job-link', wait: 10).click
      
      expect(page).to have_text('Create Job', wait: 10)

      fill_in 'job_title', with: 'Software Engineer'
      fill_in 'job_description', with: 'Exciting opportunity for software engineer.'
      select 'Full-time', from: 'job_employee_type'
      fill_in 'job_location', with: 'San Francisco'
      select '₹ 15000-20000', from: 'job_salary'
      select job_category.name, from: 'job_job_category_id'
      select 'Graduation', from: 'job_qualification'
      select 'Public', from: 'job_status'
      select marketing_agency_page.title, from: 'job_page_id'

      click_button 'Create Job'

      visit jobs_path

      # Search for the job category form
      find('#job_category', wait: 10).click

      # Select a job category
      select job_category.name, from: 'job_category'

      # Click on submit
      click_button 'Submit'
    end

    it 'go to job path when no job category exists' do

      job_category = create(:job_category)
      job_category_private = create(:job_category, name: 'Private')

      marketing_agency_page = create(:page, title: 'Marketing Agency X', user: user)
      
      visit user_my_jobs_path(user)
      
      find('#add-job-link', wait: 10).click
      
      expect(page).to have_text('Create Job', wait: 10)

      fill_in 'job_title', with: 'Software Engineer'
      fill_in 'job_description', with: 'Exciting opportunity for software engineer.'
      select 'Full-time', from: 'job_employee_type'
      fill_in 'job_location', with: 'San Francisco'
      select '₹ 15000-20000', from: 'job_salary'
      select job_category.name, from: 'job_job_category_id'
      select 'Graduation', from: 'job_qualification'
      select 'Public', from: 'job_status'
      select marketing_agency_page.title, from: 'job_page_id'

      click_button 'Create Job'

      visit jobs_path

      # Search for the job category form
      find('#job_category', wait: 10).click

      # Select a job category
      select job_category_private.name, from: 'job_category'

      # Click on submit
      click_button 'Submit'

      expect(page).to have_content('No jobs available in the Private category.')

      expect(page).to have_text('No job is present!')
    end
  end
end
