class User < ApplicationRecord
  has_many :test_results, dependent: :destroy # чтобы при удалении юзера удалялись и результаты
  has_many :tests, through: :test_results, dependent: :destroy # соответв. будут удаляться и тесты при удалении юзера
  has_many :author_tests, class_name: "Test", foreign_key: "author_id"

  def tests_by_level(level)
    tests.where(level: level)
  end
end
