require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  scenario 'user signs in with Google' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        email: 'user@example.com',
        name: 'John Doe'
      },
      credentials: {
        token: 'your_actual_token_here',
        expires_at: 1.hour.from_now.to_i
      },
      extra: { raw_info: { sub: '123456', email: 'user@example.com', name: 'John Doe' } }
    })

    visit new_user_session_path

    click_button 'Google'

    # Optionally, you can check the rendered content on the Google login page
    expect(page).to have_current_path(user_google_oauth2_omniauth_authorize_path)
    expect(page).to have_content('Sign in with Google')

    click_button 'Sign with Google'

    # Adjust the path and content according to your application's behavior after successful authentication
    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Successfully authenticated from Google account.')

    # Optionally, you may want to check if the user is now signed in
    # Modify the following line based on your user authentication logic
    expect(page).to have_content('Welcome, John Doe')

    # Add an appropriate wait time or check for asynchronous processes if needed
    # sleep 3

    # Add the SessionsController test
    expect(session[:user_id]).to be_nil # Ensure the user is not already authenticated

    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]

    get :create, params: { provider: 'google_oauth2' }

    expect(response).to redirect_to(root_path)
    expect(session[:user_id]).not_to be_nil
  end
end


