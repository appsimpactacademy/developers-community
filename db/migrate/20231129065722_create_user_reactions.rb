class CreateUserReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_reactions do |t|
      t.string :reaction_type
      t.string :reactable_id
      t.string :reactable_type
      t.integer :user_id

      t.timestamps
    end
  end
end
