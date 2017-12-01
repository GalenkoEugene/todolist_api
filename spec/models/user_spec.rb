require 'rails_helper'

RSpec.describe User, type: :model do
  it { expect(subject).to allow_value('123456789A').for(:password) }
  it { expect(subject).not_to allow_value('123456789').for(:password) }
  it { expect(subject).not_to allow_value('123AAA').for(:password) }
  it { expect(subject).to validate_length_of(:password).is_at_least(8) }
  it { expect(subject).to have_many :projects }

  let(:user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create(:project) }

  it 'project dependent destroy' do
    user.projects << project
    expect { user.destroy }.to change(Project, :count)
  end
end
