require "csv"
 
CSV.foreach('db/category_layer/first_category.csv') do |info|
  FirstCategory.create(:name => info[0])
end

CSV.foreach('db/category_layer/new_second_01.csv') do |info|
  SecondCategory.create(:name => info[0], :first_category_id => info[1])
end

CSV.foreach('db/category_layer/new_third.csv') do |info|
  ThirdCategory.create(:name => info[0], :second_category_id => info[1])
end

CSV.foreach('db/category_layer/forth_category.csv') do |info|
  ForthCategory.create(:name => info[0], :third_category_id => info[1])
end

CSV.foreach('db/category_new.csv') do |info|
  Category.create(:name => info[0], :hira => info[1], :kana=> info[2])
end