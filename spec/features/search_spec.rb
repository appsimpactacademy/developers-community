require 'rails_helper'

RSpec.feature 'Search', type: :feature do
  let(:user) { create(:user, first_name: 'John', last_name: 'Doe') }
  let(:user1) { create(:user, first_name: 'John 1', last_name: 'Doe 1') }
  let(:user2) { create(:user, first_name: 'John 2', last_name: 'Doe 2') }
  let(:user3) { create(:user, first_name: 'John 3', last_name: 'Doe 3') }

  before :each do
    sign_in(user)
    visit root_path
  end

  it 'should search for users', js: true do

    find('#search_bar', wait: 10).click

    fill_in 'query', with: 'John 1'
    debugger

    sleep 5
    
    expect(page).to have_selector('#suggestions', visible: true, wait: 10)

    # expect(page).to have_css('#search', visible: true, wait: 10)

    expect(page).to have_text('John 1 Doe 1 (User)', wait: 10)
    
    click_link 'John 1 Doe 1 (User)'

    expect(page).to have_text("Profile: #{user.first_name} #{user.last_name}")
  end
end
