# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :request do
  let(:user) { create(:user) }
  let(:record_post) { create(:post, user:) }

  before { sign_in user }

  describe 'GET /posts' do
    it 'returns a successful response' do
      get posts_path
      expect(response).to be_successful
    end
  end

  describe 'GET /posts/:id' do
    it 'returns a successful response' do
      get post_path(record_post)
      expect(response).to be_successful
    end
  end

  describe 'GET /posts/new' do
    context 'when user is signed in' do
      it 'returns a successful response' do
        get new_post_path, as: :turbo_stream
        expect(response).to be_successful
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        sign_out user
        get new_post_path, as: :turbo_stream
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /posts' do
    context 'when user is signed in' do
      context 'with valid parameters' do
        it 'creates a new post' do
          expect do
            post posts_path, params: { post: { title: 'Test post', user_id: user.id, description: 'Test Description' } },
                             as: :turbo_stream
          end.to change(Post, :count).by(1)

          expect(response).to redirect_to(root_path)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new post' do
          expect do
            post posts_path, params: { post: { title: '' } }, as: :turbo_stream
          end.not_to change(Post, :count)

          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        sign_out user
        post posts_path, params: { post: attributes_for(:post) }, as: :turbo_stream
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /posts/:id/edit' do
    context 'when user is signed in' do
      it 'returns a successful response' do
        get edit_post_path(record_post), as: :turbo_stream
        expect(response).to be_successful
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        sign_out user
        get edit_post_path(record_post), as: :turbo_stream
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /posts/:id' do
    context 'when user is signed in' do
      context 'with valid parameters' do
        it 'updates the post' do
          patch post_path(record_post), params: { post: { title: 'Updated Title' } }, as: :turbo_stream
          expect(response).to redirect_to(root_path)
        end
      end

      context 'with invalid parameters' do
        it 'does not update the post' do
          patch post_path(record_post), params: { post: { title: '' } }, as: :turbo_stream
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        sign_out user
        patch post_path(record_post), params: { post: { title: 'Updated Title' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /posts/:id' do
    it 'destroys the post' do
      record_post

      expect do
        delete post_path(record_post)
      end.to change(Post, :count).by(-1)

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET /posts/:id/hide' do
    it 'hides the post' do
      post hide_post_path(record_post)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Post is hidden')
    end
  end

  describe 'GET /posts/:id/undo_hide' do
    it 'unhides the post' do
      post undo_hide_post_path(record_post)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Post is unhidden')
    end
  end

  describe 'PATCH /posts/:id/toggle_hide' do
    it 'toggles the hide status of the post' do
      post toggle_hide_post_path(record_post), as: :json

      expect(response).to be_successful
      expect(JSON.parse(response.body)['hidden']).to eq(true)
    end
  end

  describe 'GET /posts/hidden' do
    it 'returns a successful response' do
      get hidden_posts_path
      expect(response).to be_successful
    end
  end
end
