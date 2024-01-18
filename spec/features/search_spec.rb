# spec/features/search_spec.rb

require 'rails_helper'

RSpec.feature 'Search functionality', type: :feature, js: true do
  let(:user) { create(:user, first_name: 'John', last_name: 'Doe') } # Assuming you have a User model and a factory for it

  before do
    sign_in(user)
    visit root_path
  end

  scenario 'User searches for a user and clicks on the result' do
    users = create_list(:user, 5)  
    fill_in 'search_bar', with: user.name
    expect(page).to have_content(user.name)

    expect(page).to have_css('#suggestions', visible: true)

    find('#search_users').click

    # within('#suggestions') do
    #   click_on "#{user.first_name} #{user.last_name} (User)"
    # end

    # Assuming your user profile path is something like user_path(user)
    expect(page).to have_current_path(user_path(user))
    expect(page).to have_content("#{user.first_name} #{user.last_name}'s Profile")
  end
end
