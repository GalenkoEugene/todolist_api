require 'ffaker'

User.create!(name: FFaker::Internet.user_name,
            password: FFaker::Internet.password)

