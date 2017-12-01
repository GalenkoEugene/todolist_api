require 'rails_helper'

RSpec.describe Task, type: :model do
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to belong_to :project }
end
