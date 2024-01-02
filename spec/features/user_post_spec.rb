# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User Post', type: :feature do
  describe 'User Post' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit root_path
    end

    it 'go to my post path when no posts' do
      find('#add-user-post-link', wait: 10).click
      posts_container = find('#posts-container', wait: 10)
      expect(Post.all.count).to eq(0)
      expect(posts_container).to have_text('No posts available', wait: 10)
    end

    it 'go to my post path when posts exists' do

      post = create(:post, user: user) 

      find('#add-user-post-link', wait: 10).click

      posts_container = find('#posts-container', wait: 10)
      expect(Post.all.count).to eq(1)
      expect(posts_container).to_not have_text('No posts available', wait: 10)

      visit user_posts_path(user)
      posts_container = find('#posts-container', wait: 10)
      expect(page).to have_text(post.title)
      expect(page).to have_text(post.user.name)
      expect(page).to have_text(post.description)

      click_link(post.title)

      expect(page).to have_current_path(post_path(post))

      expect(page).to have_text(post.user_id)
      expect(page).to have_text(user.name)
      expect(page).to have_text(post.title)
      expect(page).to have_text(post.description), wait: 10

      find('#comment_container', wait: 10)

      sample_comment_content = 'This is a sample comment.'

      fill_in 'comment_content', with: sample_comment_content

      click_button 'Create Comment'

      expect(page).to have_text(sample_comment_content) 

      find('#edit_post', wait: 10).click

      expect(page). to have_text('Edit Post')

      fill_in 'post_title', with: 'Sample Post'
      fill_in 'post_description', with: 'Description for sample post'

      click_button 'Save Changes'
    end
  end
end
