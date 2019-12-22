class Project < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  has_many :tasks, -> { order(position: :desc) }, dependent: :destroy

  validates_with ProjectValidator, attributes: :name
end
