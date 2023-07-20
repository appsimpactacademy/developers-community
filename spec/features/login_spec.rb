require 'rails_helper'

RSpec.feature "Logins", type: :feature do
  shared_examples 'a successful login' do |login_field|
    it "should login user with #{login_field}" do 
      user = User.create(
               email: 'user@example.com',
               password: 'password',
               username: 'example_user',
               first_name: 'Example',
               last_name: 'User',
               profile_title: 'Senior ruby on rails developer',
               confirmed_at: DateTime.now
             )

      visit root_path

      fill_in 'user_login', with: user.send(login_field)
      fill_in 'user_password', with: user.password

      click_button 'Log in'
      expect(page).to have_link('Dev Community')
      expect(page).to have_link('My Profile')
      expect(page).to have_link('My Network')
      expect(page).to have_link('Sign Out')
      expect(page).to have_text('Search professionals across the world!')
      expect(page).to have_text(user.name)
      expect(page).to have_text(user.profile_title)
    end
  end

  describe 'login' do 
    include_examples 'a successful login', :username
    include_examples 'a successful login', :email
  end
end
