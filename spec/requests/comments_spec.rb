# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { create(:user) }
  let(:post_record) { create(:post) }
  let(:valid_attributes) { { title: 'Test Comment', user_id: user.id, post_id: post_record.id } }

  before do
    sign_in user
  end

  describe 'POST /posts/:post_id/comments' do
    it 'creates a new comment' do
      post post_comments_path(post_record), params: { comment: valid_attributes }

      expect(response).to redirect_to(post_record)
      expect(flash[:notice]).to eq('Comment was successfully created.')
    end
  end

  describe 'PUT /posts/:post_id/comments/:id' do
    let(:comment) { create(:comment, user:, commentable: post_record) }
    let(:updated_title) { 'Updated Title' }

    it 'updates an existing comment' do
      put post_comment_path(post_record, comment), params: { comment: { title: updated_title } }

      expect(response).to redirect_to(post_record)
      expect(flash[:notice]).to eq('Comment was successfully updated.')

      comment.reload
      expect(comment.title).to eq(updated_title)
    end
  end

  describe 'DELETE /posts/:post_id/comments/:id' do
    let!(:comment) { create(:comment, user:, commentable: post_record) }

    it 'destroys the specified comment' do
      expect do
        delete post_comment_path(post_record, comment)
      end.to change(Comment, :count).by(-1)

      expect(response).to redirect_to(post_record)
      expect(flash[:notice]).to eq('Comment was successfully deleted.')
    end
  end
end
