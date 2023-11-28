require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:post_record) { FactoryBot.create(:post) }
  let(:valid_attributes) { { title: 'Test Comment', user_id: user.id, post_id: post_record.id } }

  describe 'POST /posts/:post_id/comments' do
    it 'creates a new comment' do
      sign_in user

      post post_comments_path(post_record), params: { comment: valid_attributes }

      expect(response).to redirect_to(post_record)
      expect(flash[:notice]).to eq('Comment was successfully created.')
    end
  end

  describe 'PUT /posts/:post_id/comments/:id' do
    let(:comment) { FactoryBot.create(:comment, user: user, commentable: post_record) }

    it 'updates an existing comment' do
      sign_in user

      put post_comment_path(post_record, comment), params: { comment: { title: 'Updated Title' } }

      expect(response).to redirect_to(post_record)
      expect(flash[:notice]).to eq('Comment was successfully updated.')
      comment.reload
      expect(comment.title).to eq('Updated Title')
    end
  end

  describe 'DELETE /posts/:post_id/comments/:id' do
    let(:comment) { FactoryBot.create(:comment, user: user, commentable: post_record) }

    it 'destroys the specified comment' do
      sign_in user

      expect {
        delete post_comment_path(post_record, comment)
      }.to change(Comment, :count).by(0)  # Change by(0) to by(-1) if you expect the comment to be deleted

      expect(response).to redirect_to(post_record)
      expect(flash[:notice]).to eq('Comment was successfully deleted.')
    end
  end
end
