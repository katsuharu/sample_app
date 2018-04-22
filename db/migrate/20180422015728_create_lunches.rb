class CreateLunches < ActiveRecord::Migration[5.0]
  def change
    create_table :lunches do |t|
      t.integer :user_id
      t.integer :category_id
      t.integer :pair_id
      t.boolean :is_deleted
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
