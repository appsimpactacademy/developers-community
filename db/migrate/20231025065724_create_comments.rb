# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, null: false
      t.string :title
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
