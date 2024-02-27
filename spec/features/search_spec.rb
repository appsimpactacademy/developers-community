# require 'rails_helper'
# require 'support/autocomplete_helpers'

# RSpec.configure do |config|
#   config.include AutocompleteHelpers, type: :feature
# end

# RSpec.feature 'Search functionality', type: :feature, js: true do
#   let(:user) { create(:user, first_name: 'John', last_name: 'Doe') }

#   before do
#     sign_in(user)
#     visit root_path
#   end

#   scenario 'User searches for a user and clicks on the result' do
#     users = create_list(:user, 5)

#     # Call the fill_in_autocomplete method
#     fill_in_autocomplete('Search Post, Jobs, Users, Events, Pages..', '.form-control', with: user.name)

#     # Check if suggestions are visible
#     expect(page).to have_selector('#search_suggestions', visible: true,)

#     # Check if the suggestions list contains the expected user
#     expect(page).to have_content("#{user.first_name} #{user.last_name} (User)")

#     # Click on the suggestion
#     click_on "#{user.first_name} #{user.last_name} (User)"

#     # Assuming your user profile path is something like user_path(user)
#     expect(page).to have_current_path(user_path(user))
#     expect(page).to have_content("#{user.first_name} #{user.last_name}'s Profile")
#   end
# end
