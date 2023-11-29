# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :title, presence: true

  include Notificable

  # for notification
  def user_ids
    User.where(id: user.connected_user_ids).ids
    # User.all.ids
  end
end
