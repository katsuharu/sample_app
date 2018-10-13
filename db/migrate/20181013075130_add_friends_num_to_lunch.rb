class AddFriendsNumToLunch < ActiveRecord::Migration[5.0]
  def change
    add_column :lunches, :friends_num, :integer, null: false, default: 0, comment: '一緒に参加する友達人数'
  end
end