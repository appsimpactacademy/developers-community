class Notification < ApplicationRecord
  scope :unviewed, -> { where(viewed: false) }
  
  belongs_to :item, polymorphic: true
  belongs_to :user

end
