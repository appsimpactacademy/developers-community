# frozen_string_literal: true

# spec/models/comment_spec.rb

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) } # You can replace :user with your User factory
  let(:post) { create(:post, user_id: user.id) } # You can replace :user with your User factory

  it 'is valid with a title, user, and commentable' do
    comment = Comment.new(title: 'A valid comment', user_id: user.id, commentable: post)
    expect(comment).to be_valid
  end

  it 'is not valid without a title' do
    comment = Comment.new(user:, commentable: post)
    expect(comment).to_not be_valid
  end

  it 'belongs to a user' do
    comment = Comment.new(user:, commentable: post)
    expect(comment.user).to be_a(User)
  end

  it 'belongs to a commentable (polymorphic)' do
    comment = Comment.new(user:, commentable: post)
    expect(comment.commentable).to be_a(Post)
  end

  it 'user_ids method # sends notifications to connected users when a comment is created' do
    user1 = create(:user)
    user2 = create(:user)

    user = create(:user, connected_user_ids: [user1.id, user2.id])
    # Use a block to capture the notification creation
    comment = Comment.new(user:, commentable: post, title: 'Test comment 1')
    # Assuming two connected users
    expect do
      comment.save
    end.to change(Notification, :count).by(2)
    expect(Notification.last.item_id).to eq(comment.id)
  end
end
