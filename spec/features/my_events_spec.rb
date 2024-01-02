# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'My Event', type: :feature do
  describe 'My Event' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'go to my event path when no event' do
      find('#my_event', wait: 10).click
      event_container = find('#user_event', wait: 10)
      expect(Event.all.count).to eq(0)
      expect(event_container).to have_text('No Event is created by you!')
    end

    it 'go to my event path when event exists' do

      event = create(:event, user: user) 

      find('#my_event', wait: 10).click
      event_container = find('#user_event', wait: 10)
      expect(Event.all.count).to eq(1)
      expect(event_container).to_not have_text('No Event is created by you!', wait: 10)
      
      visit user_my_events_path(user)
      event_container = find('#user_event', wait: 10)
      expect(page).to have_text(event.id)
      expect(page).to have_text(event.event_name)
      expect(page).to have_text(event.event_type)
      expect(page).to have_text(event.start_date)
      expect(page).to have_text(event.end_date)
      expect(page).to have_text(event.start_time)
      expect(page).to have_text(event.end_time)
      expect(page).to have_text(event.description)
    end

    it 'should view the event' do

      event = create(:event, user: user) 

      find('#my_event', wait: 10).click
      event_container = find('#user_event', wait: 10)
      expect(Event.all.count).to eq(1)
      expect(event_container).to_not have_text('No Event is created by you!', wait: 10)

      find('#view_event', wait: 10).click

      expect(page).to have_text(event.id)
      expect(page).to have_text(event.event_name)
      expect(page).to have_text(event.event_type)
      expect(page).to have_text(event.start_date)
      expect(page).to have_text(event.end_date)
      expect(page).to have_text(event.start_time)
      expect(page).to have_text(event.end_time)
      expect(page).to have_text(event.description)
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
