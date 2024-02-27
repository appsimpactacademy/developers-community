# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'SignOut', type: :feature do
  describe 'SignOut' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the root path page' do

      find('#add-signout-link', wait: 10).click

       # Accept the confirmation alert
      page.driver.browser.switch_to.alert.accept

      # Wait for the alert to be accepted
      sleep 1

      expect(page).to have_text('Signed out successfully.')
    end
  end
end
