class ChangeDatatypeProfileImgOfUsers < ActiveRecord::Migration[5.0]
  def change
  	change_column :users, :profile_img, :binary
  end
end
