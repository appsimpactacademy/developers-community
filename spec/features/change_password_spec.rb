# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Change Password', type: :feature do
  let(:user) { create(:user) }

  before :each do
    sign_in(user)
  end

  scenario 'navigates to the change password page' do
    visit member_path(user)
    click_link 'Change your password', wait: 10
    expect(page).to have_selector('#change-password-form')
  end

  scenario 'shows an error if trying to change password without entering a new password' do
    visit member_path(user)

    click_link 'Change your password', wait: 10

    click_button 'Update'

    # Expect an error message
    expect(page).to have_text("Password can't be blank")
  end

  scenario 'changes the password successfully and logs in with the new password' do
    visit member_path(user)

    click_link 'Change your password', wait: 10

    fill_in 'user_password', with: 'new_password'
    fill_in 'user_password_confirmation', with: 'new_password'

    click_button 'Update'

    # Expect to be redirected to the login page after password change
    expect(page).to have_current_path(new_user_session_path)

    # Log in again with the new password
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'new_password'
    click_button 'Log In'

    # Expect to be redirected to the user profile page after successful login
    expect(page).to have_text('Signed in successfully.')
  end

end
