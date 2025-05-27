class UserBadge < ApplicationRecord
  belongs_to :user
  belongs_to :badge

  validates :user, presence: true
  validates :badge, presence: true

  # Опционально: добавляем scope для сортировки по дате получения
  scope :by_recent, -> { order(created_at: :desc) }

  # Опционально: добавляем метод для проверки, когда был получен бейдж
  def received_at
    created_at
  end
end
