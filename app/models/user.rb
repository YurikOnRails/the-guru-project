class User < ApplicationRecord
  has_many :test_results, dependent: :destroy # чтобы при удалении пользователя удалялись и результаты
  has_many :tests, through: :test_results
  has_many :author_tests, class_name: "Test", foreign_key: "author_id"

  def tests_by_level(level)
    tests.where(level: level)
  end
end
