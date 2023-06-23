class Connection < ApplicationRecord
  CONNECTION_STATUSES = %w(pending accepted rejected deleted)
  belongs_to :user

  belongs_to :requested, foreign_key: :connected_user_id, class_name: 'User'
  belongs_to :received, foreign_key: :user_id, class_name: 'User'

  validates :connected_user_id, presence: true
  validates :status, presence: true, inclusion: { in: CONNECTION_STATUSES }
end
