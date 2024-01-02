require 'rails_helper'

RSpec.feature 'Copy URL', type: :feature do
  let(:current_user) { create(:user, username: 'current_user') }
  let(:other_user) { create(:user, username: 'other_user') }
  let(:other_user_post) { create(:post, user: other_user, title: 'Other User Post', description: 'This is a post by other_user.') }

  before :each do
    sign_in(other_user)
    visit root_path

    # create the post by other user
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

    # Click on the dropdown button
    find('#dropdownMenuLink').click

    expect(page).to have_selector('.dropdown-menu', visible: true)

    # Click on the view button
    find("#url_button_#{other_user.id}", wait: 10).click

    # Handle the alert dialog
    page.driver.browser.switch_to.alert.accept
  end

  it 'should open post show page after pasting URL' do
    # Get the copied URL
    copied_url = page.evaluate_script('navigator.clipboard.readText()')

    # Open a new tab and visit the copied URL
    new_window = window_opened_by { visit copied_url }

    # Ensure that the post show page is opened in the new tab
    within_window new_window do
      expect(page).to have_text('Other User Post')
      expect(page).to have_text('This is a post by other_user.')
    end
  end
end
