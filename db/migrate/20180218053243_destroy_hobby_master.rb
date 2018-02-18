class DestroyHobbyMaster < ActiveRecord::Migration[5.0]
  def change
  	drop_table :hobby_masters
  end
end