class User < ApplicationRecord
  devise  :database_authenticatable, :registerable, :recoverable,
          :rememberable, :validatable, :confirmable

  has_many :test_passages, dependent: :destroy # чтобы при удалении юзера удалялись и результаты
  has_many :tests, through: :test_passages, dependent: :destroy # соответв. будут удаляться и тесты при удалении юзера
  has_many :author_tests, class_name: "Test", foreign_key: "author_id", dependent: :nullify
  has_many :created_tests, class_name: "Test", foreign_key: :user_id, dependent: :destroy
  has_many :gists, dependent: :destroy

  validates :email, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, presence: true, on: :create
  validates :password, confirmation: true

  def test_results(test)
    test_results.order(id: :desk).find_by(test_id: test.id)
  end

  # Возвращает полное имя пользователя или email, если имя не указано
  def full_name
    if first_name.present? || last_name.present?
      [ first_name, last_name ].compact.join(" ")
    else
      email
    end
  end

  # Метод для проверки, является ли пользователь администратором
  def admin?
    is_a?(Admin)
  end
end
