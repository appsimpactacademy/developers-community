# spec/requests/reposts_controller_spec.rb

require 'rails_helper'

RSpec.describe RepostsController, type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post, user: other_user) }
  let(:repost) { create(:repost, user: user, post: post) }

  describe 'POST /reposts' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'creates a new repost for a post by another user' do
        expect {
          post post_reposts_path(post_id: post.id)
        }.to change(Repost, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Post reposted successfully.')
      end

      it 'does not allow reposting the same post again' do
        user.reposts.create(post: post)

        expect {
          post post_reposts_path(post_id: post.id)
        }.not_to change(Repost, :count)

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You have already reposted this post.')
      end

      it 'does not allow reposting user\'s own post' do
        user_post = create(:post, user: user)

        expect {
          post post_reposts_path(post_id: user_post.id)
        }.not_to change(Repost, :count)

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You cannot repost your own post.')
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        post post_reposts_path(post_id: post.id)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /reposts/:id' do
    context 'when user is signed in' do
      before { sign_in user }

      it 'destroys the repost' do
        repost # create the repost

        expect {
          delete post_repost_path(repost)
        }.to change(Repost, :count).by(-1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Repost removed')
      end

      it 'does not allow deleting reposts created by other users' do
        other_user_repost = create(:repost, user: other_user, post: post)

        expect {
          delete post_repost_path(other_user_repost)
        }.not_to change(Repost, :count)

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You cannot remove this repost.')
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        delete post_repost_path(repost)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
