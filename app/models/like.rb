# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  include Notificable

  # for notification
  def user_ids
    User.where(id: user.connected_user_ids).ids
    # User.all.ids
  end
end
