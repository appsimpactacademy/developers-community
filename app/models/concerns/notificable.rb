# frozen_string_literal: true

module Notificable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :item, dependent: :destroy
    after_create_commit :send_notifications_to_users
  end

  def send_notifications_to_users
    return unless respond_to? :user_ids

    user_ids = self.user_ids
    return if user_ids.blank?

    item_type = self.class.name
    item_id = id
    created_at = Time.now
    updated_at = Time.now
    viewed = false

    notifications = user_ids.map do |user_id|
      {
        user_id:,
        item_type:,
        item_id:,
        viewed:,
        created_at:,
        updated_at:
      }
    end

    Notification.insert_all(notifications)
  end
end
