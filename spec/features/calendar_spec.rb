# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Calendar functionality', type: :feature, js: true do
  let(:user) { create(:user) }

  before :each do
    sign_in(user)
    visit root_path
  end

  it 'displays an error when trying to create an event in the past' do
    find('#viewCalendarButton', wait: 10).click

    find('[data-date="2024-01-01"]').click

    # Switch to the JavaScript alert
    alert = page.driver.browser.switch_to.alert

    # Verify the alert text
    expect(alert.text).to eq('Cannot create events in the past!')

    # Accept or dismiss the alert
    alert.accept # or alert.dismiss
  end

  it 'opens the modal form when creating an event on the current date' do
    
    find('#viewCalendarButton', wait: 10).click

    find('[data-date="2024-01-11"]').click

    find('#eventModal', wait: 10).click

    expect(page).to have_text('Create Event')

    within('#eventModal') do
      fill_in 'eventName', with: 'Sample Event'
      fill_in 'eventType', with: 'Meeting'
      fill_in 'startDate', with: '2023-01-01'
      fill_in 'startTime', with: '10:00 AM'
      fill_in 'endDate', with: '2023-01-01'
      fill_in 'endTime', with: '12:00 PM'
      fill_in 'eventDescription', with: 'This is a test event description.'

      click_button 'Save changes'
    end
  end
end
