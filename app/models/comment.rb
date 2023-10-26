class Comment < ApplicationRecord
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :title, presence: true
  
end
