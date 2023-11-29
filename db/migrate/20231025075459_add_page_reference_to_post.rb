# frozen_string_literal: true

class AddPageReferenceToPost < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :page, foreign_key: true, null: true
  end
end
