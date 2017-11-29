class AddAnyCategoryToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :any_category, :integer
  end
end
