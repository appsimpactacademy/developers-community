# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'My Network', type: :feature do
  describe 'My Network' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'should open the root path page' do

      find('#add-my-network-link', wait: 10).click
      sleep 1
    end
  end
end
