# spec/requests/search_controller_spec.rb

require 'rails_helper'

RSpec.describe SearchController, type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:job) { create(:job) }
  let(:event) { create(:event) }
  let(:page) { create(:page) }

  describe 'GET /search/suggestions' do
    it 'returns a successful response with search suggestions' do
      sign_in user
      query = 'example'
      
      post search_suggestions_path, as: :turbo_stream

      expect(response).to be_successful
      expect(assigns(:results)).to include(user, post, job, event, page)
    end
  end

  describe 'GET /search/results' do
    it 'returns a successful response with search results for a user' do
      sign_in user
      other_user.follow(user)
      
      get search_results_path(user_id: other_user.id)

      expect(response).to be_successful
      expect(assigns(:user)).to eq(other_user)
      # Add more expectations based on your implementation
    end
  end
end
