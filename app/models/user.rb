class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  include DeviseTokenAuth::Concerns::User
  before_validation :set_uid
  has_many :projects, dependent: :destroy

  private

  def set_uid
    self[:uid] = self[:name] if self[:uid].blank? && self[:name].present?
  end
end
