class AddLunchDateToLunches < ActiveRecord::Migration[5.0]
  def change
    add_column :lunches, :lunch_date, :date
  end
end
