class TestPassage < ApplicationRecord
  belongs_to :test
  belongs_to :current_question, class_name: "Question", optional: true
  belongs_to :user, optional: true

  validates :correct_questions, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :test_has_questions, on: :create

  before_validation :before_validation_set_first_question, on: :create
  before_validation :before_validation_set_next_question, on: :update

  SUCCESS_THRESHOLD = 85

  def accept!(answer_ids)
    if correct_answer?(answer_ids)
      self.correct_questions += 1
    end

    save!
  end

  def success_rate
    ((correct_questions.to_f / test.questions.count) * 100).round(2)
  end

  def success?
    success_rate >= SUCCESS_THRESHOLD
  end

  def completed?
    current_question.nil? || time_out?
  end

  def question_number
    test.questions.order(:id).where('id <= ?', current_question.id).count
  end

  def time_left
    return nil unless test.timer_minutes
    
    end_time = created_at + test.timer_minutes.minutes
    seconds_left = (end_time - Time.current).to_i
    seconds_left.positive? ? seconds_left : 0
  end

  def time_out?
    return false unless test.timer_minutes
    
    time_left.zero?
  end

  private

  def before_validation_set_first_question
    self.current_question = test.questions.first if test.present?
  end

  def before_validation_set_next_question
    self.current_question = next_question
  end

  def correct_answer?(answer_ids)
    correct_answers.ids.sort == Array(answer_ids).map(&:to_i).sort
  end

  def correct_answers
    current_question.answers.correct
  end

  def next_question
    test.questions.order(:id).where('id > ?', current_question.id).first
  end

  def test_has_questions
    if test.questions.empty?
      errors.add(:base, "Тест не содержит вопросов")
    end
  end
end
