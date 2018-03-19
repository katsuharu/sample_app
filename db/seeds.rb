# User.create!(name:  "ポールマッカートニー",
#              email: "example@railstutorial.org",
#              password:              "foobar",
#              password_confirmation: "foobar",
#              department_name: "第一営業本部",
#              slack_id: "1",
#              admin: true,
#              activated: true
#              activated_at: Time.zone.now)

# User.create!(name:  "小野まさき",
#              email: "ono@gmail.com",
#              password:              "masaki",
#              password_confirmation: "masaki",
#              department_name: "VR",
#              slack_id: "2",
#              admin: true,
#              activated: true
#              activated_at: Time.zone.now)


# User.create!(name:  "五右衛門",
#              email: "tokyo@gmail.com",
#              password:              "masaki",
#              password_confirmation: "masaki",
#              department_name: "営業",
#              slack_id: "3",
#              admin: true,
#              activated: true
#              activated_at: Time.zone.now)

# User.create!(name:  "柏木大地",
#              email: "koyo@gmail.com",
#              password:              "masaki",
#              password_confirmation: "masaki",
#              department_name: "広報",
#              slack_id: "4",
#              admin: true,
#              activated: true
#              activated_at: Time.zone.now)


# User.create!(name:  "阿部慎之助",
#              email: "ocha@gmail.com",
#              password:              "masaki",
#              password_confirmation: "masaki",
#              department_name: "ゲームエンジニア",
#              slack_id: "5",
#              admin: true,
#              activated: true
#              activated_at: Time.zone.now)

# Category.create(name: ,
#                 hira: ,
#                 kana: )

# Category.create(name: ,
#                 hira: ,
#                 kana: )

require "csv"
 
CSV.foreach('db/category_db.csv') do |info|
  Category.create(:name => info[0], :hira => info[1], :kana=> info[2])
end