class Test < ApplicationRecord
  belongs_to :category, optional: true, foreign_key: :category_id
  belongs_to :author, class_name: "User", optional: true, foreign_key: :author_id
  has_many :test_results, dependent: :destroy, foreign_key: :test_id
  has_many :users, through: :test_results, foreign_key: :user_id
  has_many :questions, dependent: :destroy, foreign_key: :test_id

  def self.tests_by_category_name(category_name)
    joins("INNER JOIN categories ON categories.id = tests.category_id")
      .where("categories.name = ?", category_name)
      .order(title: :desc)
      .pluck(:title)
  end
end
