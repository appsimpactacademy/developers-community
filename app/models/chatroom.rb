# frozen_string_literal: true

class Chatroom < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'
  has_many :messages, dependent: :destroy

  scope :between_users, lambda { |user1, user2|
    where('(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)', user1.id, user2, user2, user1.id)
  }
end
