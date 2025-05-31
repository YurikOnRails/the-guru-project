class Test < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :category

  has_many :test_passages, dependent: :destroy
  has_many :users, through: :test_passages
  has_many :questions, dependent: :destroy

  validates :title, presence: true
  validates :timer_minutes, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  def self.titles_by_category_name(category_name)
    joins(:category)
      .where(categories: { name: category_name })
      .order(title: :desc)
      .pluck(:title)
  end

  def timed?
    timer_minutes.present?
  end
end
