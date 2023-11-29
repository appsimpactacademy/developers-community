# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom
  has_one_attached :cover_image

  # validation
  validates :message, presence: true

  def sent_by?(user)
    self.user == user
  end
end
