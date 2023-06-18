class Connection < ApplicationRecord
  belongs_to :user

  validates :connected_user_id, presence: true
  validates :status, presence: true, inclusion: { in: %w(pending accepted rejected deleted) }
end
