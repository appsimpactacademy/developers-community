# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Pages Post of Current User', type: :feature do
  describe 'Pages Post of Current User' do
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

      click_link 'Awesome Page'

      find('#pages_post_button', wait: 10).click
    end

    it 'should open the job form and save to db if all validation passed & create the post for page & visit the page post' do

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

      find('#pages_post_button', wait: 10).click

      expect(page).to have_text('Uploade your post')

      click_button 'Save Changes'

      expect(page).to have_text('2 errors prohibited your posts form being saved.')
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Description can't be blank")

      click_button 'Close'

      find('#pages_post_button', wait: 10).click

      expect(page).to have_text('Uploade your post')

      fill_in 'post_title', with: 'Sample Post for pages'
      fill_in 'post_description', with: 'This is a sample post description for pages.'
      click_button 'Save Changes'

      page_id = Page.last.id

      visit page_path(page_id)

      expect(page).to have_text('Sample Post for pages')
      expect(page).to have_text('This is a sample post description for pages.')

      find('#dropdownMenuLink').click

      find("#view_page_post_button_#{user.id}").click
    end

    it 'should edit the page post' do
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

      find('#pages_post_button', wait: 10).click

      expect(page).to have_text('Uploade your post')

      click_button 'Save Changes'

      expect(page).to have_text('2 errors prohibited your posts form being saved.')
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Description can't be blank")

      click_button 'Close'

      find('#pages_post_button', wait: 10).click

      expect(page).to have_text('Uploade your post')

      fill_in 'post_title', with: 'Sample Post for pages'
      fill_in 'post_description', with: 'This is a sample post description for pages.'
      click_button 'Save Changes'

      page_id = Page.last.id

      visit page_path(page_id)

      expect(page).to have_text('Sample Post for pages')
      expect(page).to have_text('This is a sample post description for pages.')

      find('#dropdownMenuLink').click

      find("#edit_page_post_button_#{user.id}").click

      expect(page).to have_text('Edit Post')

      fill_in 'post_title', with: 'Dummy page post of current user'
      fill_in 'post_description', with: 'This is a dummy page post description by current user.'
      click_button 'Save Changes'
    end

    it 'should delete the page post' do
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

      find('#pages_post_button', wait: 10).click

      expect(page).to have_text('Uploade your post')

      click_button 'Save Changes'

      expect(page).to have_text('2 errors prohibited your posts form being saved.')
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Description can't be blank")

      click_button 'Close'

      find('#pages_post_button', wait: 10).click

      expect(page).to have_text('Uploade your post')

      fill_in 'post_title', with: 'Sample Post for pages'
      fill_in 'post_description', with: 'This is a sample post description for pages.'
      click_button 'Save Changes'

      page_id = Page.last.id

      visit page_path(page_id)

      expect(page).to have_text('Sample Post for pages')
      expect(page).to have_text('This is a sample post description for pages.')

      find('#dropdownMenuLink').click

      find("#delete_page_post_button_#{user.id}").click 

      alert = page.driver.browser.switch_to.alert

      # Verify the alert text
      expect(alert.text).to eq('Are You Sure to delete ?')

      # Accept or dismiss the alert
      alert.accept
    end
  end
end
