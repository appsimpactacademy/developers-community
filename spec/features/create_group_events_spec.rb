# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create Group Event', type: :feature do
  describe 'Create Group Event' do
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

    it 'should open the group form and save to db if all validation passed & check the validation for events' do

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

      find('#group_event_list').click

      event_container = find('#user_event', wait: 10)
      expect(Event.all.count).to eq(0)
      expect(event_container).to have_text('No Event is created by you!')

      group_id = Group.last.id

      visit group_path(group_id)

      find('#group_event', wait: 10).click

      expect(page).to have_text('Add Event', wait: 10)

      click_button 'Save Changes'

      expect(page).to have_text('7 errors prohibited your events form being saved.')
      expect(page).to have_text("Event name can't be blank")
      expect(page).to have_text("Event type can't be blank")
      expect(page).to have_text("Start date can't be blank")
      expect(page).to have_text("End date can't be blank")
      expect(page).to have_text("Start time can't be blank")
      expect(page).to have_text("End time can't be blank")
      expect(page).to have_text("Description can't be blank")
    end

    it 'should open the group form and save to db if all validation passed & add the events in group' do

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

      find('#group_event', wait: 10).click

      expect(page).to have_text('Add Event', wait: 10)

      fill_in 'event_event_name', with: 'Tech Conference 2023'
      select 'Online', from: 'event_event_type'
      fill_in 'event_start_date', with: '15/12/2023' 
      select '09:00 AM', from: 'event_start_time'
      fill_in 'event_end_date', with: '16/12/2023'
      select '05:00 AM', from: 'event_end_time'
      fill_in 'event_description', with: 'A conference for technology.'

      click_button 'Save Changes'

      visit user_my_events_path(user)

      click_link 'View Event'
    end

    it 'should open the group form and save to db if all validation passed & edit the events in group' do

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

      find('#group_event', wait: 10).click

      expect(page).to have_text('Add Event', wait: 10)

      fill_in 'event_event_name', with: 'Tech Conference 2023'
      select 'Online', from: 'event_event_type'
      fill_in 'event_start_date', with: '15/12/2023' 
      select '09:00 AM', from: 'event_start_time'
      fill_in 'event_end_date', with: '16/12/2023'
      select '05:00 AM', from: 'event_end_time'
      fill_in 'event_description', with: 'A conference for technology.'

      click_button 'Save Changes'

      visit user_my_events_path(user)

      click_link 'Edit Event'

      expect(page).to have_text('Edit Event')\

      fill_in 'event_event_name', with: 'Ruby On Rails Bootcamp '
      select 'Online', from: 'event_event_type'
      fill_in 'event_start_date', with: '10/01/2024' 
      select '11:00 AM', from: 'event_start_time'
      fill_in 'event_end_date', with: '12/01/2024'
      select '05:00 PM', from: 'event_end_time'
      fill_in 'event_description', with: 'Join this Ruby on Rails Bootcamp.'

      click_button 'Save Changes'
    end

    it 'should open the group form and save to db if all validation passed & delete the events in group' do

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

      find('#group_event', wait: 10).click

      expect(page).to have_text('Add Event', wait: 10)

      fill_in 'event_event_name', with: 'Tech Conference 2023'
      select 'Online', from: 'event_event_type'
      fill_in 'event_start_date', with: '15/12/2023' 
      select '09:00 AM', from: 'event_start_time'
      fill_in 'event_end_date', with: '16/12/2023'
      select '05:00 AM', from: 'event_end_time'
      fill_in 'event_description', with: 'A conference for technology.'

      click_button 'Save Changes'

      visit user_my_events_path(user)

      click_link 'Delete Event'

      alert = page.driver.browser.switch_to.alert

      # Verify the alert text
      expect(alert.text).to eq('Are You Sure?')

      # Accept or dismiss the alert
      alert.accept
    end
  end
end
