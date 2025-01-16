class Test < ApplicationRecord
  # В комментариях постарался объяснить логику и вроде она соответствует ER. После проверки комментарии удалю.

  # 1. Связь многие ко многим с Users через TestResult
  has_many :test_results, dependent: :destroy # Показал здесь связь с промежуточной таблицей
  has_many :users, through: :test_results     # Показал связь "многие ко многим" с Users через TestResult

  # 2. Связь "многие к одному" с Users с колонкой author_id
  belongs_to :author, class_name: "User", foreign_key: :author_id, optional: true

  # 3.Связь "многие к одному" с Category с колонкой category_id
  belongs_to :category

  # 4. Связь "один ко многим" с Questions
  has_many :questions, dependent: :destroy

  def self.titles_by_category_name(category_name)
    joins(:category)
      .where(categories: { name: category_name })
      .order(title: :desc)
      .pluck(:title)
  end
end
