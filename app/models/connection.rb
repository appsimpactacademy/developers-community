class Connection < ApplicationRecord
  CONNECTION_STATUSES = %w(pending accepted rejected deleted)
  belongs_to :user

  validates :connected_user_id, presence: true
  validates :status, presence: true, inclusion: { in: CONNECTION_STATUSES }
end
