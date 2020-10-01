# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

50.times do |n| #100件シードデータを作成するということ。
  name = Faker::Name.unique.name
  email = Faker::Internet.unique.email
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               )
end

50.times do |n|
  content = Faker::Quote.famous_last_words

  post = Post.new(content: content,
                  user_id: rand(1..50),
                 )

  rand(1..10).times do
     post.images_attributes = [url: File.open("./public/images/IMG_4060.jpeg"),
                               id: post.id,
                              ]
  end

  post.save!
end
