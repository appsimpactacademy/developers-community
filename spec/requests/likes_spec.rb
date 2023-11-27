# spec/requests/likes_spec.rb

require 'rails_helper'

RSpec.describe LikesController, type: :request do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:valid_params) { { post_id: post.id } }


  describe 'POST /likes' do
    it 'creates a new like' do
      expect {
        post likes_path, params: valid_params, as: :turbo_stream
      }.to change(Like, :count).by(1)

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'DELETE /likes/:id' do
    let(:like) { create(:like, user: user, post: post) }

    it 'destroys the like' do
      sign_in user
      expect {
        delete like_path(like)
      }.to change(Like, :count).by(0)
      expect(response).to redirect_to(root_path)
    end
  end
end
