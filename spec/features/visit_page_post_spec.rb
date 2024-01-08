# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Visit Pages Post', type: :feature do
  describe 'Visit Pages Post' do
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

    it 'should open the job form and save to db if all validation passed & create the post for page & visit on that post' do

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

      # create the page post
      find('#pages_post_button', wait: 10).click

      expect(page).to have_text('Uploade your post')

      fill_in 'post_title', with: 'Sample Post for pages'
      fill_in 'post_description', with: 'This is a sample post description for pages.'
      click_button 'Save Changes'

      page_id = Page.last.id

      visit page_path(page_id)

      expect(page).to have_text('Sample Post for pages')
      expect(page).to have_text('This is a sample post description for pages.')

      find('#page_post_view_link').click

      # edit the post after creating the page post
      find('#edit_post', wait: 10).click

      expect(page). to have_text('Edit Post')

      fill_in 'post_title', with: 'Dummy Post for page'
      fill_in 'post_description', with: 'Dummy description for dummy page post'

      click_button 'Save Changes'

      expect(page).to have_text('Dummy Post for page')
      expect(page).to have_text('Dummy description for dummy page post')
    end

    it 'should create the comment on page post' do
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

      find('#page_post_view_link').click

      find('#comment_container', wait: 10)

      sample_comment_content = 'This is a sample comment for page post.'

      fill_in 'comment_content', with: sample_comment_content

      click_button 'Create Comment'

      expect(page).to have_text(sample_comment_content)

      expect(page).to have_text('Comment was successfully created.')
    end

    it 'should create & delete the comment on page post' do
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

      find('#page_post_view_link').click

      find('#comment_container', wait: 10)

      sample_comment_content = 'This is a sample comment for page post.'

      fill_in 'comment_content', with: sample_comment_content

      click_button 'Create Comment'

      expect(page).to have_text(sample_comment_content)

      expect(page).to have_text('Comment was successfully created.')

      find('#delete-comment-button', wait: 10).click
      # click_link 'Delete'

      expect(page).to have_text('Comment was successfully deleted.')
    end
  end
end
