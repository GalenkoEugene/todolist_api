require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { expect(subject).to belong_to :task }
  it { expect(subject).to validate_presence_of :body }
  it { expect(subject).to validate_length_of(:body).is_at_least(10) }
  it { expect(subject).to validate_length_of(:body).is_at_most(256) }
end
