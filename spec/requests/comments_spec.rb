# spec/requests/comments_controller_spec.rb

require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:comment) { create(:comment, post: post, user: user) }

  describe 'POST /posts/:post_id/comments' do
    it 'creates a new comment' do
      post post_comments_path(post), params: { comment: { title: 'Test Comment', user_id: user.id } }
      expect(response).to redirect_to(post_path(post))
      expect(Comment.count).to eq(1)
    end
  end


  describe "DELETE /comments/:id" do
    it "deletes a comment" do
      delete comment_path(comment)
      expect(response).to redirect_to(post)
      expect(flash[:notice]).to eq('Comment was successfully deleted.')
    end
  end

  describe "GET /comments/:id/edit" do
    it "renders the edit page" do
      get edit_comment_path(comment)
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /comments/:id" do
    it "updates a comment" do
      patch comment_path(comment), params: { comment: { title: "Updated Comment" } }
      expect(response).to redirect_to(post)
      expect(flash[:notice]).to eq('Comment was successfully updated.')
    end
  end

  describe "GET /comments/:id/show" do
    it "renders the show page" do
      get comment_path(comment)
      expect(response).to render_template(:edit)
      expect(assigns(:comment)).to be_a_new(Comment)
    end
  end
end
