class Test < ApplicationRecord
  def self.tests_by_category_name(category_name)
    joins("INNER JOIN categories ON categories.id = tests.category_id")
      .where("categories.name = ?", category_name)
      .order(title: :desc)
      .pluck(:title)
  end
end
