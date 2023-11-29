# frozen_string_literal: true

class JobCategory < ApplicationRecord
  has_many :jobs
end
