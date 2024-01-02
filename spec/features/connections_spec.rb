# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Connections', type: :feature do
  describe 'Connections' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the root path page' do

      find('#add-connection-link', wait: 10).click
      # expect(page).to have_text('connections')
    end

    it 'should open the member connection page' do

      visit member_connections_path(user)
      
      expect(page).to have_text('About', wait: 10)
    end
  end
end
