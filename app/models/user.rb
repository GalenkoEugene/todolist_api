class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :password, format: {
    with: /\A(?=.*[a-zA-Z])(?=.*\d)\S{8,}\z/,
    message: I18n.t('errors.password')
  }, confirmation: true, on: :create
  include DeviseTokenAuth::Concerns::User

  has_many :projects, dependent: :destroy
end
