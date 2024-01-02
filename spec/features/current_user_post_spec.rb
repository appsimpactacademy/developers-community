# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Post', type: :feature do
  describe 'Post' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the post form of current user and display the validation errors if empty form is submitted' do

      find('#add-post-link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      click_button 'Save Changes'

      expect(page).to have_text('2 errors prohibited your posts form being saved.')
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_text("Description can't be blank")
    end

    it 'should open the post form of current user and save to db if all validation passed and add the comments' do
      
      find('#add-post-link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      fill_in 'post_title', with: 'Sample Post'
      fill_in 'post_description', with: 'This is a sample post description.'
      click_button 'Save Changes'

      visit root_path
      expect(page).to have_text('Sample Post')
      expect(page).to have_text('This is a sample post description.')

      find('#dropdownMenuLink').click
      find("#view_post_button_#{user.id}").click

      find('#comment_container', wait: 10)
      sample_comment_content = 'This is a sample comment.'
      fill_in 'comment_content', with: sample_comment_content
      click_button 'Create Comment'
    end

    it 'should edit the post of current user' do

      find('#add-post-link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      fill_in 'post_title', with: 'Sample Post'
      fill_in 'post_description', with: 'This is a sample post description.'
      click_button 'Save Changes'

      visit root_path
      expect(page).to have_text('Sample Post')
      expect(page).to have_text('This is a sample post description.')

      find('#dropdownMenuLink').click

      find("#edit_post_button_#{user.id}").click

      expect(page).to have_text('Edit Post')

      fill_in 'post_title', with: 'Dummy Post of Current User'
      fill_in 'post_description', with: 'This is a dummy post description by current user.'
      click_button 'Save Changes'

    end

    it 'should delete the post of current user' do

      find('#add-post-link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      fill_in 'post_title', with: 'Sample Post'
      fill_in 'post_description', with: 'This is a sample post description.'
      click_button 'Save Changes'

      visit root_path
      expect(page).to have_text('Sample Post')
      expect(page).to have_text('This is a sample post description.')

      find('#dropdownMenuLink').click

      find("#delete_post_button_#{user.id}").click

      page.driver.browser.switch_to.alert.accept

      # Wait for the alert to be accepted
      sleep 1
    end
  end
end
