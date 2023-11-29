# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SharesController, type: :request do
  let(:user) { create(:user) }
  let(:record_post) { create(:post, user:) }
  let(:recipient) { create(:user) }

  before { sign_in user }

  describe 'GET /shares' do
    it 'returns a successful response with shared posts' do
      create(:post, user:)
      user.shared_posts

      get shares_path, as: :turbo_stream

      expect(response).to be_successful
    end
  end

  describe 'GET /shares/new' do
    it 'returns a successful response' do
      get new_share_path, as: :turbo_stream
      expect(response).to be_successful
      expect(assigns(:share)).to be_a_new(Share)
    end
  end

  describe 'POST /shares' do
    context 'with valid parameters' do
      let(:share_params) { { recipient_id: recipient.id, post_id: record_post.id } }

      it 'creates a new share' do
        expect do
          post shares_path, params: { share: share_params }
        end.to change(Share, :count).by(1)
      end

      it 'sends a notification email and redirects to the root path' do
        expect do
          post shares_path, params: { share: share_params }
        end.to change(ActionMailer::Base.deliveries, :count).by(1)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      it 'renders the new template' do
        post '/shares', params: { share: { invalid_param: 'invalid_value' } }, as: :turbo_stream

        expect(response).to render_template(:new)
      end
    end
  end
end
