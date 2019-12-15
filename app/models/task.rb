class Task < ApplicationRecord
  belongs_to :project
  acts_as_list scope: :project

  validates :name, presence: true

  has_many :comments, dependent: :destroy

  validates_with TaskDeadlineValidator, attributes: :deadline, if: :deadline_changed?
  validates_with TaskPositionValidator, attributes: :position, if: :position_changed?
end
