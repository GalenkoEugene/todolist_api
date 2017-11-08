class Task < ApplicationRecord
  attr_accessor :prioritize
  belongs_to :project
  has_many :comments, dependent: :destroy
  validates :name, presence: true
  validate :deadline_cant_be_in_the_past, unless: :prioritize
  acts_as_list scope: :project

  private

  def deadline_cant_be_in_the_past
    errors.add(:deadline, I18n.t('errors.task_deadlin')) if deadline.present? && deadline.past?
  end
end
