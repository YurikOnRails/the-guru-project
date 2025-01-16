class User < ApplicationRecord
  has_many :test_results, dependent: :destroy
  has_many :tests, through: :test_results

  # Тесты, которые создал пользователь
  has_many :authored_tests, class_name: "Test", foreign_key: :author_id
  def tests_by_level(level)
    tests.where(level: level)
  end
end
