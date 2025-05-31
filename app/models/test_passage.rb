class TestPassage < ApplicationRecord
  belongs_to :test
  belongs_to :current_question, class_name: "Question", optional: true
  belongs_to :user, optional: true

  validates :correct_questions, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :test_has_questions, on: :create

  before_validation :set_next_question, on: :create
  before_create :set_started_at

  SUCCESS_THRESHOLD = 85

  scope :successful, -> { where("correct_questions * 100.0 / tests_count >= ?", SUCCESS_THRESHOLD) }

  def accept!(answer_ids)
    if time_out?
      complete!
      return false
    end

    self.correct_questions += 1 if correct_answer?(answer_ids)
    self.current_question = next_question
    save!
  end

  def success_percentage
    return 0 if test.questions.count.zero?

    (correct_questions.to_f / test.questions.count * 100).round
  end

  def completed?
    current_question.nil? || time_out?
  end

  def successful?
    success_percentage >= SUCCESS_THRESHOLD
  end

  def complete!
    self.current_question = nil
    self.success = successful?
    save!
  end

  def time_out?
    return false unless test.timed?
    return false if started_at.nil?

    Time.current >= started_at + test.timer_minutes.minutes
  end

  def remaining_time
    return nil unless test.timed?
    return 0 if time_out?

    ((started_at + test.timer_minutes.minutes) - Time.current).round
  end

  private

  def set_started_at
    self.started_at = Time.current
  end

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
end
