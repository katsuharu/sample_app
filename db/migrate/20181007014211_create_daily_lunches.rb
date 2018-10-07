class CreateDailyLunches < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_lunches do |t|
      t.string :name, null: false, comment: 'ランチテーマ'
      t.date :date, null: false, comment: 'ランチ日時'
      t.integer :category_id, null: false, comment: 'カテゴリーID'
      t.datetime :deleted_at, comment: '削除日時'
      t.integer :lock_version, limit: 4, null: false, default: 0, comment: 'ロックバージョン'
      t.timestamps
    end
  end
end