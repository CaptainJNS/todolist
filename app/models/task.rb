class Task < ApplicationRecord
  belongs_to :project
  has_one :user, through: :project

  validates :name, presence: true
end
