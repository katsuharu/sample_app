class AddLoginedAtToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :logined_at, :datetime
  end
end
