class Test < ApplicationRecord
    # Связь: Один тест принадлежит одной категории
    # belongs_to :category
    # belongs_to :author, class_name: "User"

    def self.tests_by_category_name(category_name)
      joins(:category)
        .where(categories: { name: category_name })
        .order(title: :desc)
        .pluck(:title)
    end
end
