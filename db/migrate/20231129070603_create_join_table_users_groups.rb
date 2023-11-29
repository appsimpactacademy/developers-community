# frozen_string_literal: true

class CreateJoinTableUsersGroups < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :groups do |t|
      t.index %i[user_id group_id]
      t.index %i[group_id user_id]
    end
  end
end
