class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.string :industry
      t.string :website
      t.string :organization_size
      t.string :organization_type
      t.references :user, null: false, foreign_key: true
      t.text :about

      t.timestamps
    end
  end
end
