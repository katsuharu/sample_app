require "csv"

CSV.foreach('db/category_new.csv') do |info|
  Category.create(:name => info[0], :hira => info[1], :kana=> info[2])
end

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

# CSV.foreach('db/users_seeds.csv') do |info|
#   User.create(id: info[0], name: info[1], email: info[2], password: info[3], password_confirmation: info[3], department_name: info[4], slack_id: info[5], activated: info[6], activated_at: info[7])
# end

# CSV.foreach('db/lunch_seeds.csv') do |info|
#   Lunch.create(user_id: info[0], lunch_date: Date.today, category_id: info[2])
# end

# CSV.foreach('db/user_thousand.csv') do |info|
#   User.create(id: info[0], name: info[1], email: info[2], password: info[3], password_confirmation: info[3], department_name: info[4], slack_id: info[5], activated: info[6], activated_at: info[7])
# end

# CSV.foreach('db/thousand_lunches.csv') do |info|
#   Lunch.create(user_id: info[0], lunch_date: Date.today, category_id: info[1])
# end

# CSV.foreach('db/make_pair_lunches.csv') do |info|
#   Lunch.create(user_id: info[0], lunch_date: Date.today, category_id: info[1], pair_id: info[2], sent_at: DateTime.now)
# end

# CSV.foreach('db/all_pair_one_chat.csv') do |info|
#   Chat.create(text: 'a' ,user_id: info[0], pair_id: info[1], lunch_date: Date.today)
# end