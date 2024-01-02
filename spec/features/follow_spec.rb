require 'rails_helper'

RSpec.feature 'Follow', type: :feature do
  let(:current_user) { create(:user, username: 'current_user') }
  let(:other_user) { create(:user, username: 'other_user') }

  before :each do
    sign_in(other_user)
    visit root_path

    # first create the post by other user
    find('#add-post-link', wait: 10).click
    expect(page).to have_text('Uploade your post', wait: 10)

    fill_in 'post_title', with: 'Other User Post'
    fill_in 'post_description', with: 'This is a post by other_user.'
    click_button 'Save Changes'

    expect(page).to have_text('Other User Post')
    expect(page).to have_text('This is a post by other_user.')

    # Log in as current_user
    sign_in(current_user)

    # Visit root path
    visit root_path

    # Display the post created by other_user with a wait time
    expect(page).to have_text('Other User Post', wait: 10)
    expect(page).to have_text('This is a post by other_user')

    # Click on the follow button
    find("#follow_button_#{other_user.id}").click

    # Visit root path again
    visit root_path

    # Check if the post created by other_user is still visible
    expect(page).to have_text('Other User Post')
    expect(page).to have_text('This is a post by other_user')

    # Now go to followers page
    find('#add-my-followers-link', wait: 10).click
  end

  it 'go to my followers path when followers & followers exist' do

    find('#pills-home-tab', wait: 10).click

    # Switch to Following tab
    find('#pills-following-tab', wait: 10).click

    find('#pills-following', wait: 10)
    
    expect(page).to have_text(other_user.name, wait: 10)
    expect(page).to have_text(other_user.profile_title)
    expect(page).to have_text(other_user.email)
  end
end
