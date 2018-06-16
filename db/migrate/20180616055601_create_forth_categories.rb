class CreateForthCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :forth_categories do |t|
      t.string :name
      t.integer :third_category_id

      t.timestamps
    end
  end
end
