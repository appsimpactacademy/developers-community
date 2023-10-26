class CreateShares < ActiveRecord::Migration[7.0]
  def change
    create_table :shares do |t|
      t.references :post, null: false, foreign_key: true
      t.references :sender, references: :users, null: false
      t.references :recipient, references: :users, null: false

      t.timestamps
    end
  end
end
