User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             department_name: "第一営業本部",
             entry_id: 1,
             admin: true,
             activated: true)

User.create!(name:  "小野まさき",
             email: "ono@gmail.com",
             password:              "masaki",
             password_confirmation: "masaki",
             department_name: "VR",
             entry_id: 1,
             admin: true,
             activated: true)


User.create!(name:  "東京タワー",
             email: "tokyo@gmail.com",
             password:              "masaki",
             password_confirmation: "masaki",
             department_name: "営業"
             admin: true,
             entry_id: 1,
             activated: true)

User.create!(name:  "紅葉",
             email: "koyo@gmail.com",
             password:              "masaki",
             password_confirmation: "masaki",
             department_name: "広報"
             admin: true,
             activated: true)


User.create!(name:  "おーいお茶",
             email: "ocha@gmail.com",
             password:              "masaki",
             password_confirmation: "masaki",
             department_name: "ゲームエンジニア",
             admin: true,
             entry_id: 11,
             activated: true)