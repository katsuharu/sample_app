class DropUserHobby < ActiveRecord::Migration[5.0]
  def change
  	drop_table :user_hobbies
  end
end