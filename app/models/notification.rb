class Notification < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :user

  scope :unviewed, -> { where(viewed: false) }
end
