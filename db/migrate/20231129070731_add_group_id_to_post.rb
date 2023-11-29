class AddGroupIdToPost < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :group, null: true, foreign_key: true
  end
end
