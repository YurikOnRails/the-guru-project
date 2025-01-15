class TestResult < ApplicationRecord
  belongs_to :user, optional: true, foreign_key: :user_id
  belongs_to :test, optional: true, foreign_key: :test_id
end
