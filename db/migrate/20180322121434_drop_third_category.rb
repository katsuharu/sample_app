class DropThirdCategory < ActiveRecord::Migration[5.0]
  def change
  	drop_table :third_categories
  end
end