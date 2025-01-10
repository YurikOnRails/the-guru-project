class User < ApplicationRecord
  has_many :test_results
  has_many :tests, through: :test_results

  #метод выдает только завершенные тесты
  def tests_by_level(level)
    tests.where(level: level).where(test_results: { completed: true })
  end
end
