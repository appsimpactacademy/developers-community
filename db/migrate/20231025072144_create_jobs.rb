# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :description
      t.string :employee_type
      t.string :location
      t.string :salary
      t.string :qualification
      t.string :status
      t.references :job_category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
