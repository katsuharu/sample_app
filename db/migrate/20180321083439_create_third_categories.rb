class CreateThirdCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :third_categories do |t|
      t.string :name
      t.integer :second_category_id

      t.timestamps
    end
  end
end
