class AddPositionidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :position_id, :integer
  end
end
