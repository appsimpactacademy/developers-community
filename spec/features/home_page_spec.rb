# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'HomePages', type: :feature do
  describe 'Landing page' do
    it 'should show the login form on root page' do
      visit root_path
      expect(page).to have_text('Dev Community')
      expect(page).to have_text('Log in')
      expect(page).to have_link('Sign Up')
      expect(page).to have_link('Forgot your password?')

      expect(page).to_not have_text('Search professionals across the world!')
    end
  end
end
