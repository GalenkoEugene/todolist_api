FactoryGirl.define do
  factory :user do
    email     { FFaker::Internet.email }
    password  { FFaker::Internet.password + '1a' }
  end
end
