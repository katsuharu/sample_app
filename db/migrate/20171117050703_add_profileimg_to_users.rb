class AddProfileimgToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile_img, :string
  end
end
