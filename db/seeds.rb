require 'ffaker'

User.destroy_all
Project.destroy_all

User.create!(email: 'some@email.com', password: 123456789)
User.create!(email: FFaker::Internet.email, password: FFaker::Internet.password)

7.times{ Project.create!(name: FFaker::HipsterIpsum.word, user: User.all.sample) }

puts ' Done! '.center(50, '=')
