class AddLockVersionToForthCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :forth_categories, :lock_version, :integer, limit:4, null: false, default: 0, comment: 'ロックバージョン'
  end
end
