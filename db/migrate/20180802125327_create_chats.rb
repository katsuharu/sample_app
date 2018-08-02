class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.text :text, comment: 'テキスト'
      t.integer :user_id, comment: 'ユーザーID'
      t.integer :pair_id, comment: 'ペアID'
      t.date :lunch_date, comment: 'ランチ日時'
      t.datetime :deleted_at, comment: '削除日時'
      t.integer :lock_version, limit: 4, null: false, default: 0, comment: 'ロックバージョン'
      t.timestamps
    end
  end
end