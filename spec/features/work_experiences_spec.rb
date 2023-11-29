# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'WorkExperiences', type: :feature do
  describe 'Work Experiences' do
    describe 'Current user' do
      before :each do
        @user = create(:user)
        sign_in(@user)
        sleep 1
      end

      it 'should open the work experience form and display the validation errors if empty form is submitted' do
        visit "/member/#{@user.id}"
        expect(page).to have_text('Work Experiences')
        find('a[data-controller="bs-modal-form"] i.bi.bi-plus').click
        sleep 1
        expect(page).to have_text('Add new work experience')
        click_button 'Save Changes'
        sleep 5
        expect(page).to have_text('9 errors prohibited your work experience frm being saved.')
        expect(page).to have_text("Company can't be blank")
        expect(page).to have_text("Start date can't be blank")
        expect(page).to have_text("Job title can't be blank")
        expect(page).to have_text("Location can't be blank")
        expect(page).to have_text("Employment type can't be blank")
        expect(page).to have_text('Employment type not a valid employment type')
        expect(page).to have_text("Location type can't be blank")
        expect(page).to have_text('Location type not a valid location type')
        expect(page).to have_text('End date must be present if you are not currently working in this company')
        sleep 2
      end

      it 'should open the work experience form and save to db if all validation passed' do
        visit "/member/#{@user.id}"
        expect(page).to have_text('Work Experiences')
        find('a[data-controller="bs-modal-form"] i.bi.bi-plus').click
        sleep 1
        expect(page).to have_text('Add new work experience')

        fill_in 'work_experience_job_title', with: 'Senior Ruby on Rails developer'
        fill_in 'work_experience_company', with: 'Developer Community PVT. LTD.'
        select 'Full-time', from: 'work_experience_employment_type'
        fill_in 'work_experience_location', with: 'Indore, India'
        select 'Remote', from: 'work_experience_location_type'
        fill_in 'work_experience_start_date', with: '01/01/2018'
        fill_in 'work_experience_end_date', with: '31/12/2020'
        fill_in 'work_experience_description',
                with: 'I worked here for two years as a full stack Ruby on Rails developer'
        sleep 5
        click_button 'Save Changes'
        visit "/member/#{@user.id}"
        expect(page).to have_text('Senior Ruby on Rails developer')
        expect(page).to have_text('Developer Community PVT. LTD. (Full-time)')
        expect(page).to have_text('Indore, India (Remote)')
        expect(page).to have_text('Jan 2018 - Dec 2020 (2 years 11 months)')
        sleep 5
      end
    end
  end
end
