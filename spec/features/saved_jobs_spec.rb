# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'SavedJobs', type: :feature do
  describe 'SavedJobs' do
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


    it 'go to job path for save the job after creating the job' do

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

      find('#saved_jobs', wait: 10).click

      expect(page).to have_text('Job saved successfully.')

      # Try to save the same job again
      visit jobs_path

      find('#saved_jobs', wait: 10).click

      expect(page).to have_text('You have already saved this job.')
      
      expect(user.saved_jobs.count).to eq(1) # Make sure the count remains the same

      # for visiting the saved job page
      find('#view_saved_jobs', wait: 10).click
    end

    it 'should delete the saved job after creating the job & saved it' do
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

      find('#saved_jobs', wait: 10).click

      expect(page).to have_text('Job saved successfully.')

      find('#delete_saved_jobs', wait: 10).click

      alert = page.driver.browser.switch_to.alert

      # Verify the alert text
      expect(alert.text).to eq('Are you sure?')

      # Accept or dismiss the alert
      alert.accept

      expect(page).to have_text('Job removed from saved jobs.')
    end
  end
end
