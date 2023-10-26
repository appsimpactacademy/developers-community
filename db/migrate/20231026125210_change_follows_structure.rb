class ChangeFollowsStructure < ActiveRecord::Migration[7.0]
  def up
    # Remove the existing 'follows' table
    drop_table :follows

    # Create a new 'follows' table with a polymorphic association
    create_table :follows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :followed, polymorphic: true, index: true

      t.timestamps
    end
  end

  def down
    # Revert the changes if needed
    drop_table :follows
    create_table :follows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :page, null: false, foreign_key: true

      t.timestamps
    end
  end
end
