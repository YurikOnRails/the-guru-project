class Test < ApplicationRecord
  belongs_to :category
  belongs_to :author, class_name: "User", optional: true

  has_many :test_results, dependent: :destroy
  has_many :users, through: :test_results
  has_many :questions, dependent: :destroy

  scope :by_category_name, ->(category_name) do
    joins(:category)
      .where(categories: { name: category_name })
      .order(title: :desc)
  end

  def self.titles_by_category_name(category_name)
    by_category_name(category_name).pluck(:title)
  end
end
