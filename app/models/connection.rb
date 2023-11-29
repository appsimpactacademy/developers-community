# frozen_string_literal: true

class Connection < ApplicationRecord
  CONNECTION_STATUSES = %w[pending accepted rejected deleted].freeze
  belongs_to :user

  belongs_to :requested, foreign_key: :connected_user_id, class_name: 'User', optional: true
  belongs_to :received, foreign_key: :user_id, class_name: 'User', optional: true

  validates :connected_user_id, presence: true
  validates :status, presence: true, inclusion: { in: CONNECTION_STATUSES }

  def status_btn
    case status
    when 'accepted'
      'btn btn-success'
    when 'rejected'
      'btn btn-danger'
    else
      'btn btn-primary'
    end
  end
end
