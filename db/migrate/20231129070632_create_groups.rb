class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.string :industry
      t.string :location
      t.string :group_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
