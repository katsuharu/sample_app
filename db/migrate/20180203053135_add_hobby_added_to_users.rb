class AddHobbyAddedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :hobby_added, :integer
  end
end
