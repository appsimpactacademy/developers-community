# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'My Profile', type: :feature do
  describe 'My Profile' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the root path page' do
      find('#add-user-profile-link', wait: 10).click
    end

    it 'should open the member connection page' do
      visit member_path(user)
    end
  end
end
