require 'ffaker'

User.destroy_all

User.create!(email: 'some@email.com', password: 123456789)

7.times do
  Project.create!(
    name: FFaker::HipsterIpsum.word,
    user: User.all.sample)
end

Project.all.each do |project|
  project.tasks.create!(name: FFaker::HipsterIpsum.words.join(', '))
  project.tasks.create!(name: FFaker::HipsterIpsum.words.join(', '))
end

puts ' Done! '.center(50, '=')
