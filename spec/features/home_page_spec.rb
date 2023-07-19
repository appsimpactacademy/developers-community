require 'rails_helper'

RSpec.feature "HomePages", type: :feature do
  describe 'Landing page' do 
    it 'should show the login form on root page' do 
      visit root_path

      expect(page).to have_text('Dev Community')
      expect(page).to have_text('Login')
      expect(page).to have_link('Sign up')
      expect(page).to have_link('Forgot your password?')
      expect(page).to have_link("Didn't receive confirmation instructions?")

      expect(page).to_not have_text('Search professionals accross the world!')
      debugger
    end
  end
end
