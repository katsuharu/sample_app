class CreateSecondCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :second_categories do |t|
      t.string :name
      t.integer :first_category_id

      t.timestamps
    end
  end
end
