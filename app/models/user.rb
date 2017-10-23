class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :password, confirmation: true
  include DeviseTokenAuth::Concerns::User

  has_many :projects, dependent: :destroy
end
