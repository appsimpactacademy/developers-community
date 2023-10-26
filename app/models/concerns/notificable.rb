module Notificable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :item, dependent: :destroy
    after_create_commit :send_notifications_to_users
  end

  def send_notifications_to_users
    if self.respond_to? :user_ids
      user_ids = self.user_ids
      return if user_ids.blank?

      item_type = self.class.name
      item_id = self.id
      created_at = Time.now
      updated_at = Time.now
      viewed = false

      notifications = user_ids.map do |user_id|
        {
          user_id: user_id,
          item_type: item_type,
          item_id: item_id,
          viewed: viewed,
          created_at: created_at,
          updated_at: updated_at
        }
      end

      Notification.insert_all(notifications)
    end
  end
end
