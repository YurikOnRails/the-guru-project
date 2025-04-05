# Preview all emails at http://localhost:3000/rails/mailers/tests_mailer
class TestsMailerPreview < ActionMailer::Preview
  def completed_test
    # Находим существующий тестовый проход или создаем новый с правильными атрибутами
    test_passage = TestPassage.find_by(id: 1) ||
                  TestPassage.create!(
                    user_id: User.first.id,
                    test_id: Test.first.id,
                    correct_questions: 5
                  )

    TestsMailer.completed_test(test_passage)
  end
end
