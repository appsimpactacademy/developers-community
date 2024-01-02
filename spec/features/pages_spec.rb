# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Pages', type: :feature do
  describe 'Pages' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should have Pages text on nav-bar' do
      find('#pages', wait: 10).click
      visit pages_path
      expect(page).to have_text('New Page', wait: 10)
    end

    # it 'should open the page form and display the validation errors if empty form is submitted' do

    #   # find('#add-page-link', wait: 10).click
    #   expect(page).to have_text('New Page', wait: 10)

    #   click_button 'Create Page'

    #   expect(page).to have_text('7 errors prohibited your jobs form being saved.')
    #   expect(page).to have_text("Title can't be blank")
    #   expect(page).to have_text("Website can't be blank")
    #   expect(page).to have_text("Organization type can't be blank")
    #   expect(page).to have_text("Organization size can't be blank")
    #   expect(page).to have_text("Industry can't be blank")
    #   expect(page).to have_text("Content can't be blank")
    #   expect(page).to have_text("About can't be blank")
    # end

    it 'should open the job form and save to db if all validation passed' do

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
  end
end
