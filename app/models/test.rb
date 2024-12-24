class Test < ApplicationRecord
  belongs_to :category
  has_many :questions, dependent: :destroy

  validates :title, presence: true
  validates :level, numericality: { greater_than_or_equal_to: 0 }
end
