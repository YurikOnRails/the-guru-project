class Test < ApplicationRecord
  belongs_to :author,
             class_name: "User",
             foreign_key: "user_id"

  belongs_to :category

  has_many :test_results, dependent: :destroy
  has_many :users, through: :test_results, dependent: :destroy
  has_many :questions, dependent: :destroy

  def self.titles_by_category_name(category_name)
    joins(:category)
      .where(categories: { name: category_name })
      .order(title: :desc)
      .pluck(:title)
  end
end
