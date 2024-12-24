class Question < ApplicationRecord
  belongs_to :test
  has_many :answers, dependent: :destroy

  validates :content, presence: true
end
