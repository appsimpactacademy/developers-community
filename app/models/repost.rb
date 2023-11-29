# frozen_string_literal: true

class Repost < ApplicationRecord
  belongs_to :post
  belongs_to :user
end
