class AddLockVersionToTThread < ActiveRecord::Migration[5.0]
  def change
    add_column :t_threads, :lock_version, :integer, limit:4, null: false, default: 0, comment: 'ロックバージョン'
  end
end
