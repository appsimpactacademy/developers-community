# spec/requests/search_controller_spec.rb

require 'rails_helper'

RSpec.describe SearchController, type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'GET /search/suggestions' do
    it 'returns suggestions for the search query' do
      sign_in user
      post search_suggestions_path, params: { query: user.name }, as: :turbo_stream

      expect(response).to have_http_status(:ok)
      # Add additional expectations based on your specific implementation
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
