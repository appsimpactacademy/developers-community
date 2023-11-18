# spec/requests/my_events_spec.rb
require 'rails_helper'

RSpec.describe 'MyEvents', type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET /my_events' do
    it 'returns a successful response' do
      get user_my_events_path(user)
      expect(response).to be_successful
    end

    it 'assigns events for the current user' do
      events = create_list(:event, 3, user: user)
      other_user_event = create(:event) # Event belonging to another user

      get user_my_events_path(user)
      expect(assigns(:events)).to match_array(events)
      expect(assigns(:events)).not_to include(other_user_event)
    end

    it 'renders the index template' do
      get user_my_events_path(user)
      expect(response).to render_template(:index)
    end
  end
end
