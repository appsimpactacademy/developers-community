# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Reposts With Thought Page Post', type: :feature do
  describe 'Reposts With Thought Page Post' do
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

    it 'should open the page post form and save to db if all validation passed & add repost the post with thought' do

      find('#pages', wait: 10).click

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

      fill_in 'post_title', with: 'Sample Post for pages'
      fill_in 'post_description', with: 'This is a sample post description for pages.'
      click_button 'Save Changes'

      page_id = Page.last.id

      visit page_path(page_id)

      expect(page).to have_text('Sample Post for pages')
      expect(page).to have_text('This is a sample post description for pages.')

      # repost the page post with thought
      find('#repost_with_thought').click
      expect(page).to have_text('Repost with your thought')
      fill_in 'repost_thought', with: 'This is a dummy thought for reposting.'
      
      click_button 'Repost'

      expect(page).to have_text('Post reposted successfully with your thought.')

      page_id = Page.last.id

      visit page_path(page_id)

      expect(page).to have_text('Sample Post for pages')
      expect(page).to have_text('This is a sample post description for pages.')

      expect(page).to have_text('Reposted by You')

      find('#view_repost').click
    end

    it 'should open the group post form and save to db if all validation passed & delete repost the post with thought' do

      find('#pages', wait: 10).click

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

      fill_in 'post_title', with: 'Sample Post for pages'
      fill_in 'post_description', with: 'This is a sample post description for pages.'
      click_button 'Save Changes'

      page_id = Page.last.id

      visit page_path(page_id)

      expect(page).to have_text('Sample Post for pages')
      expect(page).to have_text('This is a sample post description for pages.')

      # repost the page post with thought
      find('#repost_with_thought').click
      expect(page).to have_text('Repost with your thought')
      fill_in 'repost_thought', with: 'This is a dummy thought for reposting.'
      
      click_button 'Repost'

      expect(page).to have_text('Post reposted successfully with your thought.')

      page_id = Page.last.id

      visit page_path(page_id)

      expect(page).to have_text('Sample Post for pages')
      expect(page).to have_text('This is a sample post description for pages.')

      expect(page).to have_text('Reposted by You')

      find('#view_repost').click

      find('#delete_repost').click

      alert = page.driver.browser.switch_to.alert

      # Verify the alert text
      expect(alert.text).to eq('Are you sure?')

      # Accept or dismiss the alert
      alert.accept
    end
  end
end
