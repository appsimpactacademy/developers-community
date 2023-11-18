# spec/models/post_spec.rb

require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) } # Assuming you have a factory for User

  it 'is valid with a title and description' do
    post = build(:post, user: user, title: 'Test Title', description: 'Test Description')
    expect(post).to be_valid
  end

  it 'is not valid without a title' do
    post = build(:post, user: user, title: nil, description: 'Test Description')
    expect(post).not_to be_valid
  end

  it 'is not valid without a description' do
    post = build(:post, user: user, title: 'Test Title', description: nil)
    expect(post).not_to be_valid
  end

  it 'has many images' do
    post = create(:post, user: user)
    image1 = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'download.jpeg'), 'image/jpeg')
    image2 = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'dummy.jpg'), 'image/jpeg')
    post.images.attach(image1, image2)
    expect(post.images.first.blob.filename).to eq('download.jpeg')
  end

  it 'has many comments' do
    post = create(:post, user: user)
    comment = create(:comment, commentable: post, user: user) # Assuming you have a factory for comments
    expect(post.comments).to include(comment)
  end

  it 'has many likes' do
    post = create(:post, user: user)
    like = create(:like, post: post, user: user)
    expect(post.likes).to include(like)
  end

  it 'has many users through likes' do
    post = create(:post, user: user)
    user2 = create(:user)
    like = create(:like, post: post, user: user2)
    expect(post.users).to include(user2)
  end

  it 'has many post_visits' do
    post = create(:post, user: user)
    visit = create(:post_visit, post: post, user: user) # Assuming you have a factory for post_visits
    expect(post.post_visits).to include(visit)
  end

  it 'belongs to a user' do
    post = create(:post, user: user)
    expect(post.user).to eq(user)
  end

  it 'belongs to a page (optional)' do
    page = create(:page, user: user) # Assuming you have a factory for pages
    post = create(:post, user: user, page: page)
    expect(post.page).to eq(page)
  end

  it 'defines hidden_posts scope' do
    hidden_post = create(:post, user: user, hidden: true)
    visible_post = create(:post, user: user, hidden: false)
    expect(Post.hidden_posts).to include(hidden_post)
    expect(Post.hidden_posts).not_to include(visible_post)
  end

  it 'defines hide method' do
    post = create(:post, user: user)
    post.hide
    expect(post.hidden).to eq(true)
  end

  it 'defines unhide method' do
    post = create(:post, user: user, hidden: true)
    post.unhide
    expect(post.hidden).to eq(false)
  end

  it 'defines visited_by? method' do
    post = create(:post, user: user)
    visitor = create(:user)
    post_visit = create(:post_visit, post: post, user: visitor) # Assuming you have a factory for post_visits
    expect(post.visited_by?(visitor)).to eq(true)
  end

  it 'defines ransackable_attributes method' do
    expect(Post.ransackable_attributes).to eq(["created_at", "description", "id", "title", "updated_at", "user_id"])
  end

  it 'defines ransackable_associations method' do
    expect(Post.ransackable_associations).to eq(["comments", "images_attachment", "image_blob", "user"])
  end
end
