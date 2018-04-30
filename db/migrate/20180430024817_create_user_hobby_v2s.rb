class CreateUserHobbyV2s < ActiveRecord::Migration[5.0]
  def change
    create_table :user_hobbies do |t|
      t.integer :user_id
      t.integer :hobby_id
      t.string :hobby_name

      t.timestamps
    end
  end
end
