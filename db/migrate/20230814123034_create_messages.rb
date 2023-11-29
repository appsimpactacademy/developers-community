# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :message

      t.timestamps
    end
    add_reference :messages, :user, null: false, foreign_key: true
  end
end
