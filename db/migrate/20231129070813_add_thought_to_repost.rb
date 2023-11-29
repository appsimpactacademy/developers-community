# frozen_string_literal: true

class AddThoughtToRepost < ActiveRecord::Migration[7.0]
  def change
    add_column :reposts, :thought, :text
  end
end
