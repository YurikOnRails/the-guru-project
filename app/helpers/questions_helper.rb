module QuestionsHelper
  def question_header(question)
    action = question.new_record? ? "Create New Question:" : "Edit Question:"
    "#{action} #{question.test.title}"
  end
end
