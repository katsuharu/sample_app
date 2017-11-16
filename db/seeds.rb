User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true)

User.create!(name:  "小野まさき",
             email: "ono@gmail.com",
             password:              "masaki",
             password_confirmation: "masaki",
             admin: true,
             activated: true)


users = User.order(:created_at).take(2)
3.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end