class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :department_name
      t.string :slack_id
      t.integer :entry_id
      t.integer :pair_id

      t.timestamps
    end
  end
end
