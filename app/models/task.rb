class Task < ApplicationRecord
  belongs_to :project
  validates :name, presence: true
  validate :deadline_cant_be_in_the_past

  private

  def deadline_cant_be_in_the_past
    errors.add(:deadline, "can't be in the past") if deadline.present? && deadline.past?
  end
end
