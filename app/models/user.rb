class User < ApplicationRecord
  has_many :test_results, dependent: :destroy # Связь с результатами тестов
  has_many :tests, through: :test_results # Связь с тестами через результаты тестов

  # Выдает тесты, принимая level в качествен аргумента
  def tests_by_level(level)
    Test.joins("INNER JOIN test_results ON test_results.test_id = tests.id")
        .where("test_results.user_id = ? AND tests.level = ?", id, level)
  end
end
