class User < ApplicationRecord

  # Выдает тесты, принимая level в качествен аргумента
  def tests_by_level(level)
    tests.where(level: level)
  end
end
