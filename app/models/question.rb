class Question < ApplicationRecord
  # Связь: Один вопрос может иметь много ответов
  # has_many :answers, dependent: :destroy
end
