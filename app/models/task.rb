class Task < ApplicationRecord
  belongs_to :project
  has_one :user, through: :project

  validates :name, presence: true

  has_many :comments, dependent: :destroy

  validates_with TaskDeadlineValidator, attributes: :deadline
  validates_with TaskPositionValidator, attributes: :position
end
