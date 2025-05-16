class Question < ApplicationRecord
  belongs_to :test

  has_many :answers, dependent: :destroy

  def shuffled_answers
    @shuffled_answers ||= answers.shuffle
  end
end
