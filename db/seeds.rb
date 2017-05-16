# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#User.create!(name:  "Example User",
#             email: "example@railstutorial.org",
#             password:              "foobar",
#             password_confirmation: "foobar",
#             admin: true,
#             activated: true,
#             activated_at: Time.zone.now)



#99.times do |n|
#  name  = Faker::Name.name
#  email = "examples-#{n+1}@railstutorial.org"
#  password = "password"
#  User.create!(name:  name,
#               email: email,
#               password:              password,
#               password_confirmation: password,
#               activated: true,
#               activated_at: Time.zone.now)
#end


9.times do |n|
  postname = "AnnouncementPost-#{n+1}"
  content = "Announcement-#{n+1}"
  user_id = "1"
  subforum_id = "10"
  Post.create!(postname: postname,
            content: content,
            user_id: user_id,
            subforum_id: subforum_id, 
            sticky: false)
end

