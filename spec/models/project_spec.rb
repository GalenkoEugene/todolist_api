require 'rails_helper'

RSpec.describe Project, type: :model do
  it { expect(subject).to belong_to :user }
  it { expect(subject).to validate_presence_of :name }
  it {
    expect(subject).to validate_uniqueness_of(:name)
      .scoped_to(:user_id)
      .with_message(/The project with such name does already exist/)
  }
  it { expect(subject).to have_many(:tasks).dependent :destroy }
end
