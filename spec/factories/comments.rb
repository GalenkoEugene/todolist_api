FactoryGirl.define do
  factory :comment do
    body { FFaker::HipsterIpsum.words }
    attachment 'MyString'
    task
  end
end
