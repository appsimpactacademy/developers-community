require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /create' do
    it 'successfully authenticates user with Google account' do
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

      get '/auth/google_oauth2/callback', params: { provider: 'google_oauth2' }

      expect(response).to redirect_to(root_path)
      expect(session[:user_id]).not_to be_nil
    end
  end
end
