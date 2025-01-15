class Answer < ApplicationRecord
  belongs_to :question, optional: true, foreign_key: :question_id
end
