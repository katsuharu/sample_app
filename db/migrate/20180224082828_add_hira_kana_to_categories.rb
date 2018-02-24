class AddHiraKanaToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :hira, :string
    add_column :categories, :kana, :string
  end
end
