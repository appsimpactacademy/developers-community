# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Like or Dislike the group post', type: :feature do
  describe 'Like or Dislike the group post' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the group form and display the validation errors if empty form is submitted' do

      find('#groups', wait: 10).click

      visit groups_path

      click_link 'Create Group'

      expect(page).to have_text('Create Group')

      click_button 'Create Group'

      expect(page).to have_text('5 errors prohibited your groups form being saved')
      expect(page).to have_text("Name can't be blank")
      expect(page).to have_text("Description can't be blank")
      expect(page).to have_text("Industry can't be blank")
      expect(page).to have_text("Location can't be blank")
      expect(page).to have_text("Group type can't be blank")
    end

    it 'should open the group form and save to db if all validation passed & like the group post' do

      find('#groups', wait: 10).click

      visit groups_path

      click_link 'Create Group'

      expect(page).to have_text('Create Group')

      fill_in 'group_name', with: 'Tech Enthusiasts'
      fill_in 'group_description', with: 'A group for tech discussions.'
      select 'Software Development', from: 'group_industry'
      fill_in 'group_location', with: 'San Francisco'
      select 'Public', from: 'group_group_type'

      click_button 'Create Group'

      visit groups_path

      expect(page).to have_text('Tech Enthusiasts')
    
      click_link 'View'

      group_id = Group.last.id

      visit group_path(group_id)

      # create the group post
      find('#group_post_link', wait: 10).click
      expect(page).to have_text('Uploade your post', wait: 10)

      fill_in 'post_title', with: 'Sample Post for group'
      fill_in 'post_description', with: 'This is a sample post description for group.'
      click_button 'Save Changes'

      group_id = Group.last.id

      visit group_path(group_id)

      expect(page).to have_text('Sample Post for group')
      expect(page).to have_text('This is a sample post description for group.')

      # Like the group post
      find('#group_like_button', wait: 10).click
    
      group_id = Group.last.id

      visit group_path(group_id)
  
      expect(page).to have_text('Sample Post for group')
      expect(page).to have_text('This is a sample post description for group.')

       # Dislike the group post
      find('#group_dislike_button', wait: 10).click
    end
  end
end