class RenameEntryIdColumnToUsers < ActiveRecord::Migration[5.0]
  def change
  	rename_column :users, :entry_id, :category_id
  end
end
