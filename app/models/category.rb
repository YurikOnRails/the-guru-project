class Category < ApplicationRecord
  # Связь: Одна категория может содержать много тестов
  # has_many :tests, dependent: :destroy
end
