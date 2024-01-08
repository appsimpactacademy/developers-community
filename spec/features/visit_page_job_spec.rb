# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Visit Pages Job', type: :feature do
  describe 'Visit Pages Job' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the page form and display the validation errors if empty form is submitted' do

      find('#pages', wait: 10).click

      visit pages_path

      find('#add-page-link', wait: 10).click

      expect(page).to have_text('New Page', wait: 10)

      click_button 'Create Page'

      expect(page).to have_text('7 errors prohibited your pages form being saved.')
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Content can't be blank")
      expect(page).to have_text("Industry can't be blank")
      expect(page).to have_text("Website can't be blank")
      expect(page).to have_text("Organization size can't be blank")
      expect(page).to have_text("Organization type can't be blank")
      expect(page).to have_text("About can't be blank")
    end

    it 'should open the page form and save to db if all validation passed' do

      visit pages_path
      
      find('#add-page-link', wait: 10).click
      
      expect(page).to have_text('New Page', wait: 10)

      fill_in 'page_title', with: 'Awesome Page'
      fill_in 'page_website', with: 'https://www.example.com'
      select 'Private', from: 'page_organization_type'
      select '11-50 employees', from: 'page_organization_size'
      select 'Software Development', from: 'page_industry'
      fill_in 'page_content', with: 'Exciting content about the page.'
      fill_in 'page_about', with: 'About the awesome page.'

      click_button 'Create Page'

      visit pages_path
      expect(page).to have_text('Awesome Page')
      expect(page).to have_text('Exciting content about the page.')
      expect(page).to have_text('Software Development')
      expect(page).to have_text('11-50 employees')
    end

    it 'should open the page form and save to db if all validation passed & create the job for page' do

      visit pages_path
      
      find('#add-page-link', wait: 10).click
      
      expect(page).to have_text('New Page', wait: 10)

      fill_in 'page_title', with: 'Awesome Page'
      fill_in 'page_website', with: 'https://www.example.com'
      select 'Private', from: 'page_organization_type'
      select '11-50 employees', from: 'page_organization_size'
      select 'Software Development', from: 'page_industry'
      fill_in 'page_content', with: 'Exciting content about the page.'
      fill_in 'page_about', with: 'About the awesome page.'

      click_button 'Create Page'

      visit pages_path
      expect(page).to have_text('Awesome Page')
      expect(page).to have_text('Exciting content about the page.')
      expect(page).to have_text('Software Development')
      expect(page).to have_text('11-50 employees')

      click_link 'Awesome Page'

      visit root_path

      job_category = create(:job_category)

      marketing_agency_page = create(:page, title: 'Awesome Page Job', user: user)

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
    end

    it 'should create the job for page & visit on that page job' do

      visit pages_path
      
      find('#add-page-link', wait: 10).click
      
      expect(page).to have_text('New Page', wait: 10)

      fill_in 'page_title', with: 'Awesome Page'
      fill_in 'page_website', with: 'https://www.example.com'
      select 'Private', from: 'page_organization_type'
      select '11-50 employees', from: 'page_organization_size'
      select 'Software Development', from: 'page_industry'
      fill_in 'page_content', with: 'Exciting content about the page.'
      fill_in 'page_about', with: 'About the awesome page.'

      click_button 'Create Page'

      visit pages_path
      expect(page).to have_text('Awesome Page')
      expect(page).to have_text('Exciting content about the page.')
      expect(page).to have_text('Software Development')
      expect(page).to have_text('11-50 employees')

      click_link 'Awesome Page'

      visit root_path

      job_category = create(:job_category)

      marketing_agency_page = create(:page, title: 'Awesome Page Job', user: user)

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

      page_id = Page.last.id

      visit page_path(page_id)

      find('#pages_job', wait: 10).click

      click_link 'Edit'

      expect(page).to have_text('Edit Job')

      fill_in 'job_title', with: 'Ruby Developer'
      fill_in 'job_description', with: 'Looking for a skilled Ruby developer with experience in Rails.'
      select 'Full-time', from: 'job_employee_type'
      fill_in 'job_location', with: 'Remote'
      select '₹ 25000-30000', from: 'job_salary'
      select job_category.name, from: 'job_job_category_id'
      select 'Post Graduation', from: 'job_qualification'
      select 'Public', from: 'job_status'
      select marketing_agency_page.title, from: 'job_page_id'

      click_button 'Update Job'
    end
  end
end
