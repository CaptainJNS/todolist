class Project < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  has_many :tasks, dependent: :destroy

  validates_with ProjectValidator, attributes: :name
end
