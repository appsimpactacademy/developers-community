# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'My Followers', type: :feature do
  describe 'My Followers' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'go to my followers & following path' do
      
      find('#add-my-followers-link', wait: 10).click
      
      visit followers_and_following_member_path(user)

      followers_container = find('#followers_container', wait: 10)
      
      click_button 'Followers'
      
      expect(page).to have_text('No followers are present.', wait: 10)

      click_button 'Following'
      
      expect(page).to have_text('This user is not following anyone.', wait: 10)
    end
  end
end
