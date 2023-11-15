# spec/controllers/comments_controller_spec.rb

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:valid_attributes) { { title: 'Test Comment', user_id: user.id } }
  let(:invalid_attributes) { { title: nil, user_id: user.id } }

  before { sign_in user }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, params: { post_id: post.id, comment: valid_attributes }
        }.to change(Comment, :count).by(1)
      end

      it "redirects to the post" do
        post :create, params: { post_id: post.id, comment: valid_attributes }
        expect(response).to redirect_to(post)
      end
    end

    context "with invalid params" do
      it "does not create a new Comment" do
        expect {
          post :create, params: { post_id: post.id, comment: invalid_attributes }
        }.to change(Comment, :count).by(0)
      end

      it "redirects back to the post" do
        post :create, params: { post_id: post.id, comment: invalid_attributes }
        expect(response).to redirect_to(post)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { create(:comment, commentable: post, user: user) }

    it "destroys the requested comment" do
      expect {
        delete :destroy, params: { id: comment.to_param }
      }.to change(Comment, :count).by(-1)
    end

    it "redirects back to the post" do
      delete :destroy, params: { id: comment.to_param }
      expect(response).to redirect_to(post)
    end
  end

  describe "GET #edit" do
    let(:comment) { create(:comment, commentable: post, user: user) }

    it "renders the edit template" do
      get :edit, params: { id: comment.to_param }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    let(:comment) { create(:comment, commentable: post, user: user) }

    context "with valid params" do
      let(:new_attributes) { { title: 'Updated Comment' } }

      it "updates the requested comment" do
        patch :update, params: { id: comment.to_param, comment: new_attributes }
        comment.reload
        expect(comment.title).to eq('Updated Comment')
      end

      it "redirects to the post" do
        patch :update, params: { id: comment.to_param, comment: new_attributes }
        expect(response).to redirect_to(post)
      end
    end

    context "with invalid params" do
      it "redirects back to the post" do
        patch :update, params: { id: comment.to_param, comment: invalid_attributes }
        expect(response).to redirect_to(post)
      end
    end
  end

  describe "GET #show" do
    let(:comment) { create(:comment, commentable: post, user: user) }

    it "renders the edit template" do
      get :show, params: { id: comment.to_param }
      expect(response).to render_template(:edit)
    end
  end
end
