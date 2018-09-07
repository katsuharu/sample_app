class AddSentAtToChat < ActiveRecord::Migration[5.0]
  def change
    add_column :chats, :sent_at, :datetime, comment: '投稿通知メール送信時刻'
  end
end