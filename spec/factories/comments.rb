FactoryGirl.define do
  factory :comment do
    body { FFaker::Lorem.sentences }
    attachment 'MyString'
    task
  end
end
