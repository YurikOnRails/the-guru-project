class Answer < ApplicationRecord
  # Связь: Один ответ принадлежит одному вопросу
  belongs_to :question
end
