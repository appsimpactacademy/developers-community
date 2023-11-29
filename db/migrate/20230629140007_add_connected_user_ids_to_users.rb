# frozen_string_literal: true

class AddConnectedUserIdsToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :connected_user_ids, :integer, array: true, default: []

    ActiveRecord::Base.transaction do
      User.find_each do |user|
        requested_connections = Connection.includes(:requested).where(user_id: user.id, status: 'accepted')
        received_connections = Connection.includes(:received).where(connected_user_id: user.id, status: 'accepted')
        connected_user_ids = requested_connections.pluck(:connected_user_id) + received_connections.pluck(:user_id)
        User.where(id: user.id).update_all(connected_user_ids:)
      end
    end
  end

  def down
    remove_column :users, :connected_user_ids, :integer
  end
end
