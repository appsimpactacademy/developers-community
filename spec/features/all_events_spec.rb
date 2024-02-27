# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'All Events', type: :feature do
  describe 'All Events' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the event form and display the validation errors if empty form is submitted' do

      find('#add-event-link', wait: 10).click
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

    it 'should open the event form and save to db if all validation passed' do
      
      find('#add-event-link', wait: 10).click
      
      expect(page).to have_text('Add Event', wait: 10)

      # fill_in 'event_event_type', with: 'Online'
      fill_in 'event_event_name', with: 'Tech Conference 2023'
      select 'Online', from: 'event_event_type'
      fill_in 'event_start_date', with: '15/12/2023' 
      select '09:00 AM', from: 'event_start_time'
      fill_in 'event_end_date', with: '16/12/2023'
      select '05:00 AM', from: 'event_end_time'
      fill_in 'event_description', with: 'A conference for technology.'

      click_button 'Save Changes'

      visit events_path

      expect(page).to have_text('Tech Conference 2023')
      expect(page).to have_text('Online')
      expect(page).to have_text('2023-12-15')
      expect(page).to have_text('09:00 AM')
      expect(page).to have_text('2023-12-16')
      expect(page).to have_text('05:00 AM')
      expect(page).to have_text('A conference for technology.')

      find('#view_event', wait:10).click
    end

    it 'edit the event' do

      event = create(:event, user: user) 

      find('#my_event', wait: 10).click
      event_container = find('#user_event', wait: 10)
      expect(Event.all.count).to eq(1)
      expect(event_container).to_not have_text('No Event is created by you!', wait: 10)
      
      visit user_my_events_path(user)
      event_container = find('#user_event', wait: 10)
      find('#edit_event', wait: 10).click

      expect(page).to have_text('Edit Event')

      fill_in 'event_event_name', with: 'Tech Conference 2023'
      select 'Online', from: 'event_event_type'
      fill_in 'event_start_date', with: '15/12/2023' 
      select '09:00 AM', from: 'event_start_time'
      fill_in 'event_end_date', with: '16/12/2023'
      select '05:00 AM', from: 'event_end_time'
      fill_in 'event_description', with: 'A conference for technology.'
      click_button 'Save Changes'
    end

    it 'should delete the event' do

      event = create(:event, user: user) 

      find('#my_event', wait: 10).click
      event_container = find('#user_event', wait: 10)
      expect(Event.all.count).to eq(1)
      expect(event_container).to_not have_text('No Event is created by you!', wait: 10)
      
      visit user_my_events_path(user)
      event_container = find('#user_event', wait: 10)
      find('#delete_event', wait: 10).click

      # Accept the confirmation alert
      page.driver.browser.switch_to.alert.accept

      # Wait for the alert to be accepted
      sleep 1

      # Now you can continue with your expectations or other actions
      expect(page).to have_text('No event is present')
    end
  end
end
