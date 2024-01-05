# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Events', type: :feature do
  describe 'Events' do
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

      fill_in 'event_event_name', with: 'Tech Conference 2023'
      select 'Online', from: 'event_event_type'
      fill_in 'event_start_date', with: '15/12/2023' 
      select '09:00 AM', from: 'event_start_time'
      fill_in 'event_end_date', with: '16/12/2023'
      select '05:00 AM', from: 'event_end_time'
      fill_in 'event_description', with: 'A conference for technology.'

      click_button 'Save Changes'

      sleep 1

      visit events_path
      expect(page).to have_text('Tech Conference 2023')
      expect(page).to have_text('Online')
      expect(page).to have_text('2023-12-15')
      expect(page).to have_text('09:00 AM')
      expect(page).to have_text('2023-12-16')
      expect(page).to have_text('05:00 AM')
      expect(page).to have_text('A conference for technology.')
      sleep 1
    end
  end
end
