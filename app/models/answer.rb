class Answer < ApplicationRecord
  belongs_to :question
  validates :content, presence: true

  scope :correct, -> { where(correct: true) }
end
