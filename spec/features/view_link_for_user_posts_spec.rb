# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'View Link for User Post', type: :feature do
  describe 'View Link for User Post' do
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

    it 'should open the post form of current user and save to db if all validation passed and visit on post which is upload by the user' do
      
      find('#add-post-link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      fill_in 'post_title', with: 'Dummy Post'
      fill_in 'post_description', with: 'This is a dummy post description.'
      click_button 'Save Changes'

      visit root_path
      expect(page).to have_text('Dummy Post')
      expect(page).to have_text('This is a dummy post description.')

      find('#direct_link_for_user_post', wait: 10).click

      find('#comment_container', wait: 10)

      sample_comment_content = 'This is a sample comment.'

      fill_in 'comment_content', with: sample_comment_content

      click_button 'Create Comment'

      expect(page).to have_text(sample_comment_content) 

      find('#edit_post', wait: 10).click

      expect(page). to have_text('Edit Post')

      fill_in 'post_title', with: 'Sample Post'
      fill_in 'post_description', with: 'Description for sample post'

      click_button 'Save Changes'
    end
  end
end
