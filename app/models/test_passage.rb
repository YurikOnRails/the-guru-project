class TestPassage < ApplicationRecord
  belongs_to :test
  belongs_to :current_question, class_name: "Question", optional: true
  belongs_to :user, optional: true
  has_many :user_badges, dependent: :destroy

  validates :correct_questions, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :test_has_questions, on: :create

  before_validation :set_next_question, on: :create
  after_update :award_badges, if: :completed?

  SUCCESS_THRESHOLD = 85

  def accept!(answer_ids)
    self.correct_questions += 1 if correct_answer?(answer_ids)
    self.current_question = next_question
    save!
  end

  def success_percentage
    return 0 if test.questions.count.zero?

    (correct_questions.to_f / test.questions.count * 100).round
  end

  def completed?
    current_question.nil?
  end

  def successful?
    success_percentage >= SUCCESS_THRESHOLD
  end

  private

  def set_next_question
    self.current_question = test.questions.first if test.present? && current_question.nil?
  end

  def correct_answer?(answer_ids)
    correct_answers.ids.sort == Array(answer_ids).map(&:to_i).sort
  end

  def correct_answers
    current_question.answers.correct
  end

  def next_question
    test.questions.order(:id).where("id > ?", current_question.id).first
  end

  def test_has_questions
    if test.questions.empty?
      errors.add(:base, "Тест не содержит вопросов")
    end
  end

  def award_badges
    BadgeService.new(self).call if successful?
  end
end
