class Question < ApplicationRecord
  belongs_to :test, optional: true, foreign_key: :test_id
  has_many :answers, dependent: :destroy
end
