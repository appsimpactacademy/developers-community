# frozen_string_literal: true

class AddPageRefrenceToJob < ActiveRecord::Migration[7.0]
  def change
    add_reference :jobs, :page, foreign_key: true
  end
end
