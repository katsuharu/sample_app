class AddAvatarDataUriToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar_data_uri, :string
  end
end
