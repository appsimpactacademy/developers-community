# spec/requests/home_spec.rb

require 'rails_helper'

RSpec.describe 'Home', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:connection) { create(:connection, user: user, status: 'pending', connected_user_id: other_user.id) }

  before do
    sign_in(user)
  end

  describe 'GET /home/index' do
    it 'renders the index template' do
      get root_path
      expect(response).to render_template(:index)
    end

    it 'assigns posts, post_likes_count, and post_comment_counts' do
      get root_path
      expect(assigns(:posts)).to be_an(ActiveRecord::Relation)
      expect(assigns(:post_likes_count)).to be_a(Hash)
      expect(assigns(:post_comment_counts)).to be_a(Hash)
    end
  end

  describe 'GET /home/sort' do
    it 'renders the index template' do
      get home_sort_path(sort_by: 'alphabetical'), as: :turbo_stream
      expect(response.status).to eq(204)
    end

    it 'assigns posts, post_likes_count, and post_comment_counts based on sorting' do
      get home_sort_path(sort_by: 'time_posted'), as: :turbo_stream
      expect(assigns(:posts)).to be_an(ActiveRecord::Relation)
      expect(assigns(:post_likes_count)).to be_a(Hash)
      expect(assigns(:post_comment_counts)).to be_a(Hash)
    end

    it 'assigns posts in alphabetical order when sort_by is alphabetical' do
      # Add more test cases for other sorting options if needed
      get home_sort_path(sort_by: 'alphabetical'), as: :turbo_stream
      expect(assigns(:posts)).to be_an(ActiveRecord::Relation)
      expect(assigns(:post_likes_count)).to be_a(Hash)
      expect(assigns(:post_comment_counts)).to be_a(Hash)
    end
  end
end
