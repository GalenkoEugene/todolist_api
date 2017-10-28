class Project < ApplicationRecord
  belongs_to :user
  validates :name,
            presence: true,
            uniqueness: {
              scope: :user,
              message: 'The project with such name does already exist.'
            }
end
