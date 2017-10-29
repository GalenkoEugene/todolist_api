class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: {
              scope: :user_id,
              message: 'The project with such name does already exist.'
            }
end
