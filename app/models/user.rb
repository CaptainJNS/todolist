class User < ApplicationRecord
  has_secure_password

  validates :username,
            presence: true,
            uniqueness: true,
            length: { minimum: Constants::USERNAME_MIN_LENGTH, maximum: Constants::USERNAME_MAX_LENGTH }

  validates :password, presence: true, length: { minimum: Constants::PASSWORD_MIN_LENGTH }

  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects, dependent: :destroy
  has_many :comments, through: :tasks, dependent: :destroy
end
