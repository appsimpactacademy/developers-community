# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LikesController, type: :request do
  let(:user) { create(:user) }
  let(:post_record) { create(:post, user:) }
  let(:valid_params) { { like: { post_id: post_record.id } } }

  before { sign_in user }

  describe 'POST /likes' do
    it 'creates a new like' do
      expect do
        post likes_path, params: valid_params, as: :turbo_stream
      end.to change(Like, :count).by(1)

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'DELETE /likes/:id' do
    let(:like) { create(:like, user:, post: post_record) }

    it 'destroys the like' do
      expect do
        delete like_path(like)
      end.to change(Like, :count).by(0)

      expect(response).to redirect_to(root_path)
    end
  end
end
