class Follow < ApplicationRecord
  belongs_to :user
  belongs_to :followed, polymorphic: true
end
