# frozen_string_literal: true

class UserReaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactable, polymorphic: true
end
