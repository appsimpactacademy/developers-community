class DropTablePostVisit < ActiveRecord::Migration[7.0]
  def change
    drop_table :post_visits
  end
end
