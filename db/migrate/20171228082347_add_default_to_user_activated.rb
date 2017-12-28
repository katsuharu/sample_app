class AddDefaultToUserActivated < ActiveRecord::Migration[5.0]
  def change
  	change_column_default(:users, :activated, false)
  end
end