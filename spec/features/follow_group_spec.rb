# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Follow & Unfollow Group', type: :feature do
  describe 'Follow & Unfollow Group' do
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

    it 'should open the article form and save to db if all validation passed & view the group then follow or unfollow the group' do

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

      visit groups_path

      expect(page).to have_text('Tech Enthusiasts')

      click_link 'View'

      group_id = Group.last.id

      visit group_path(group_id)

      find('#follow_group_button').click

      expect(page).to have_text('You have followed the group.', wait: 10)

      find('#unfollow_group_button').click

      expect(page).to have_text('You have unfollowed the group.', wait: 10)
    end
  end
end
