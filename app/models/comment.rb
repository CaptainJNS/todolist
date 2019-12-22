class Comment < ApplicationRecord
  belongs_to :task
  has_one_attached :image

  validates :body, presence: true
  validates_with ImageValidator, attributes: :image
end
