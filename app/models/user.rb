class User < ApplicationRecord
  # has_many :test_results
  # has_many :tests, through: :test_results

  # Выдает тесты, принимая level в качествен аргумента
  def tests_by_level(level)
    tests.where(level: level)
  end
end
