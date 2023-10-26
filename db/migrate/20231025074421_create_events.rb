class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :event_type
      t.string :event_name
      t.date :start_date
      t.date :end_date
      t.string :start_time
      t.string :end_time
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
