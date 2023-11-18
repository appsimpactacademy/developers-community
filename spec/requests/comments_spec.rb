require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  let(:user) { create(:user) } # Assuming you have a User factory
  let(:post) { create(:post, user: user) } # Assuming you have a Post factory

  describe 'POST /posts/:post_id/comments' do
    context 'with valid parameters' do
      it 'creates a new comment' do
        sign_in user
        comment_params = attributes_for(:comment) # Assuming you have a Comment factory
        expect {
          post post_comments_path(post), params: { comment: comment_params }, as: :turbo_stream
        }.to change(Comment, :count).by(1)
        expect(response).to redirect_to(post)
        expect(flash[:notice]).to eq('Comment was successfully created.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new comment' do
        sign_in user
        comment_params = attributes_for(:comment, title: nil) # Invalid parameters
        expect {
          post post_comments_path(post), params: { comment: comment_params }, as: :turbo_stream
        }.not_to change(Comment, :count)
        expect(response).to redirect_to(post)
        expect(flash[:alert]).to eq('Error creating comment.')
      end
    end
  end

  describe 'DELETE /posts/:post_id/comments/:id' do
    it 'destroys the comment' do
      sign_in user
      comment = create(:comment, user: user, commentable: post) # Assuming you have a Comment factory
      expect {
        delete post_comment_path(post, comment), as: :turbo_stream
      }.to change(Comment, :count).by(-1)
      expect(response).to redirect_to(post)
      expect(flash[:notice]).to eq('Comment was successfully deleted.')
    end
  end

  describe 'PATCH /posts/:post_id/comments/:id' do
    context 'with valid parameters' do
      it 'updates the comment' do
        sign_in user
        comment = create(:comment, user: user, commentable: post) # Assuming you have a Comment factory
        new_title = 'Updated Title'
        patch post_comment_path(post, comment), params: { comment: { title: new_title } }
        expect(comment.reload.title).to eq(new_title)
        expect(response).to redirect_to(post)
        expect(flash[:notice]).to eq('Comment was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the comment' do
        sign_in user
        comment = create(:comment, user: user, commentable: post) # Assuming you have a Comment factory
        patch post_comment_path(post, comment), params: { comment: { title: nil } }
        expect(comment.reload.title).not_to be_nil
        expect(response).to redirect_to(post)
        expect(flash[:alert]).to eq('Comment was not updated.')
      end
    end
  end
end
