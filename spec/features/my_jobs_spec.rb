# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'My Jobs', type: :feature do
  describe 'My Jobs' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'go to my job path when no job' do
      find('#my-job', wait: 10).click
      jobs_container = find('#user_jobs', wait: 10)
      expect(user.jobs.count).to eq(0)
      expect(jobs_container).to have_text('No job is created by you! So create the job first.')
    end

    # it 'go to my job path when job exists' do

    #   find('#add-job-link', wait: 10).click
    #   expect(page).to have_text('Create Job', wait: 10)

    #   click_button 'Create Job'

    #   expect(page).to have_text('9 errors prohibited your jobs form being saved.')
    #   expect(page).to have_text("Title can't be blank")
    #   expect(page).to have_text("Content can't be blank")
    # end

    it 'go to my job path when job exists' do

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
      

      click_link('View Job', class: 'btn-primary', wait: 10)

      expect(page).to have_text('Software Engineer')
      expect(page).to have_text('Exciting opportunity for')
      expect(page).to have_text('San Francisco')
      expect(page).to have_text('₹ 15000-20000')
      expect(page).to have_text('Full-time')
      expect(page).to have_text(job_category.name)
    end

    it 'should view the created job' do

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

      click_link('View Job', class: 'btn-primary', wait: 10)

      expect(page).to have_text('Software Engineer')
      expect(page).to have_text('Exciting opportunity for')
      expect(page).to have_text('San Francisco')
      expect(page).to have_text('₹ 15000-20000')
      expect(page).to have_text('Full-time')
      expect(page).to have_text(job_category.name)
    end

    it 'should edit the job' do

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

      technical_agency_page = create(:page, title: 'Technical Agency', user: user)

      click_link('Edit', class: 'btn-primary', wait: 10)
      
      expect(page).to have_text('Edit Job', wait: 10)

      fill_in 'job_title', with: 'Mechanical Engineer'
      fill_in 'job_description', with: 'Exciting opportunity for mechanical engineer.'
      select 'Part-time', from: 'job_employee_type'
      fill_in 'job_location', with: 'Bhopal'
      select '₹ 25000-30000', from: 'job_salary'
      select job_category.name, from: 'job_job_category_id'
      select 'Post Graduation', from: 'job_qualification'
      select 'Public', from: 'job_status'
      select technical_agency_page.title, from: 'job_page_id'
      click_button 'Update Job'
    end

    it 'should delete the job' do

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

      click_link('Delete', class: 'btn-primary', wait: 10)

      # Accept the confirmation alert
      page.driver.browser.switch_to.alert.accept

      # Wait for the alert to be accepted
      sleep 1

      # Now you can continue with your expectations or other actions
      expect(page).to have_text('No job is present')
    end
  end
end
