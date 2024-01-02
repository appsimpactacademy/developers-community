class Article < ApplicationRecord
  belongs_to :user
  validates :title, :content, presence: true
end
