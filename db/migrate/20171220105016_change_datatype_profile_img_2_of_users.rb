class ChangeDatatypeProfileImg2OfUsers < ActiveRecord::Migration[5.0]
  def change
  	change_column :users, :profile_img, :string
  end
end
