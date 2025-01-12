class User < ApplicationRecord
  # Выдает тесты, принимая level в качествен аргумента
  def tests_by_level(level)
    Test.joins("INNER JOIN test_results ON test_results.test_id = tests.id")
        .where("test_results.user_id = ? AND tests.level = ?", id, level)
  end
end
