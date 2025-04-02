require "digest/sha1"

class User < ApplicationRecord
  has_many :test_passages, dependent: :destroy # чтобы при удалении юзера удалялись и результаты
  has_many :tests, through: :test_passages, dependent: :destroy # соответв. будут удаляться и тесты при удалении юзера
  has_many :author_tests, class_name: "Test", foreign_key: "author_id"

  has_secure_password

  validates :email, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, presence: true, on: :create
  validates :password, confirmation: true

  def test_results(test)
    test_results.order(id: :desk).find_by(test_id: test.id)
  end
end
