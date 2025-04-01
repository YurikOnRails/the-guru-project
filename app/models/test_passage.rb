class TestPassage < ApplicationRecord

  belongs_to :user
  belongs_to :test
  belongs_to :current_question, class_name: "Question",  optional: true

  before_validation :before_validation_set_first_question

  def completed?
    current_question.nil?
  end

  def accept!(answer_ids)
    if correct_answer?(answer_ids)
      self.current_question += 1
    end

    self.current_question = next_question
    save!
  end

  private
  def before_validation_set_first_question
    self.current_question = test.questions.first if test.present?
  end
  def correct_answers
    current_question.answers.correct
  end
  def correct_answer?(answer_ids)
    correct_answers.count = correct_answers.count

    (correct_answers_count == correct_answers.where(id: answer_ids).count) &&
      correct_answers_count == answer_ids.count
  end

  def next_question
    if current_question
      test.questions.where('id > ?', current_question.id).first
    else
      test.questions.first
    end
  end

  def before_validation_set_current_question
    self.current_question = next_question
  end
end
