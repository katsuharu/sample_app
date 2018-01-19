class CreateHobbyMasters < ActiveRecord::Migration[5.0]
  def change
    create_table :hobby_masters do |t|
      t.integer :hobby_id
      t.integer :user_id

      t.timestamps
    end
  end
end
