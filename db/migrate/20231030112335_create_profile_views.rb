# frozen_string_literal: true

class CreateProfileViews < ActiveRecord::Migration[7.0]
  def change
    create_table :profile_views do |t|
      t.references :viewer, null: false, foreign_key: { to_table: :users }
      t.references :viewed_user, null: false, foreign_key: { to_table: :users }
      t.datetime :viewed_at

      t.timestamps
    end
  end
end
