class Category < ApplicationRecord
  has_many :tests, dependent: :nullify # чтобы установить category_id в NULL для связанных тестов при удалении
end
