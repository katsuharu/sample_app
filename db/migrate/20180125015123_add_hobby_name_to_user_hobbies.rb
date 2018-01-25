class AddHobbyNameToUserHobbies < ActiveRecord::Migration[5.0]
  def change
    add_column :user_hobbies, :hobby_name, :string
  end
end