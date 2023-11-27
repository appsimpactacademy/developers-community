# spec/requests/posts_controller_spec.rb

require 'rails_helper'

RSpec.describe PostsController, type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post, user: user) }

  describe 'GET /posts' do
    it 'returns a successful response' do
      sign_in user
      get posts_path
      expect(response).to be_successful
    end
  end

  describe 'GET /posts/:id' do
    it 'returns a successful response' do
      sign_in user
      get post_path(post)
      expect(response).to be_successful
    end
  end

  describe 'GET /posts/new' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'returns a successful response' do
        get new_post_path, as: :turbo_stream
        expect(response).to be_successful
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        get new_post_path, as: :turbo_stream
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /posts' do
    context 'when user is signed in' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'creates a new post' do
          expect {
            post posts_path, params: { post: attributes_for(:post) }, as: :turbo_stream
          }.to change(Post, :count).by(1)

          expect(response).to redirect_to(root_path)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new post' do
          expect {
            post posts_path, params: { post: { title: '' } }, as: :turbo_stream
          }.not_to change(Post, :count)

          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        post posts_path, params: { post: attributes_for(:post) }, as: :turbo_stream
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /posts/:id/edit' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'returns a successful response' do
        get edit_post_path(post), as: :turbo_stream
        expect(response).to be_successful
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        get edit_post_path(post)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /posts/:id' do
    context 'when user is signed in' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'updates the post' do
          patch post_path(post), params: { post: { title: 'Updated Title' } }, as: :turbo_stream
          expect(response).to redirect_to(root_path)
        end
      end

      context 'with invalid parameters' do
        it 'does not update the post' do
          patch post_path(post), params: { post: { title: '' } }, as: :turbo_stream
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        patch post_path(post), params: { post: { title: 'Updated Title' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /posts/:id' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'destroys the post' do
        post # create the post

        expect {
          delete post_path(post)
        }.to change(Post, :count).by(-1)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        delete post_path(post)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /posts/:id/hide' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'hides the post' do
        get hide_post_path(post)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Post is hidden')
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        get hide_post_path(post)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /posts/:id/undo_hide' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'unhides the post' do
        get undo_hide_post_path(post)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Post is unhidden')
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        get undo_hide_post_path(post)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /posts/:id/toggle_hide' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'toggles the hide status of the post', :json do
        post toggle_hide_post_path(post)

        expect(response).to be_successful
        expect(JSON.parse(response.body)['hidden']).to eq(true)
      end
    end

    context 'when user is not signed in' do
      it 'returns a 401 Unauthorized status', :json do
        post toggle_hide_post_path(post)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /posts/hidden' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'returns a successful response' do
        get hidden_posts_path
        expect(response).to be_successful
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        get hidden_posts_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
