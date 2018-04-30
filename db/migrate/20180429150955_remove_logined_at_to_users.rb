class RemoveLoginedAtToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :logined_at, :datetime
  end
end
