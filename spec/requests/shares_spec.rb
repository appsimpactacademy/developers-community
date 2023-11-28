# spec/requests/shares_controller_spec.rb

require 'rails_helper'

RSpec.describe SharesController, type: :request do
  let(:user) { create(:user) }
  let(:record_post) { create(:post, user: user) }
  let(:recipient) { create(:user) }

  describe 'GET /shares' do
    it 'returns a successful response with shared posts' do
      sign_in user
      shared_post = create(:post, user: user)
      user.shared_posts

      get shares_path, as: :turbo_stream

      expect(response).to be_successful
    end
  end

  describe 'GET /shares/new' do
    it 'returns a successful response' do
      sign_in user
      get new_share_path, as: :turbo_stream
      expect(response).to be_successful
      expect(assigns(:share)).to be_a_new(Share)
    end
  end

  describe 'POST /shares' do
    context 'with valid parameters' do
      it 'creates a new share' do
        sign_in user
        share_params = { recipient_id: recipient.id, post_id: record_post.id }
        expect {
          post shares_path, params: { share: share_params }
        }.to change(Share, :count).by(1)
      end

      it 'sends a notification email and redirects to the root path' do
        sign_in user
        share_params = { recipient_id: recipient.id, post_id: record_post.id }
        expect {
          post shares_path, params: { share: share_params }
        }.to change(ActionMailer::Base.deliveries, :count).by(1)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      it 'renders the new template' do
        sign_in user
        post '/shares', params: { share: { invalid_param: 'invalid_value' } }, as: :turbo_stream

        expect(response).to render_template(:new)
      end
    end
  end
end
