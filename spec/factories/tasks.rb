FactoryGirl.define do
  factory :task do
    name { FFaker::HipsterIpsum.word }
    deadline { Time.zone.tomorrow }
    done false
    project
  end
end
