class Category < ApplicationRecord
  has_many :tests, dependent: :destroy, foreign_key: :category_id
end
