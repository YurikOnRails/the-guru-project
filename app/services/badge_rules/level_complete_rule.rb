require_relative "base_rule"

module BadgeRules
  class LevelCompleteRule < BaseRule
    def satisfied?
      level = @rule_value.to_i
      tests_on_level = Test.where(level: level).pluck(:id)
      passed_tests = @user.test_passages.successful.where(test_id: tests_on_level).pluck(:test_id).uniq
      (tests_on_level - passed_tests).empty?
    end

    def error_reason(_badge = nil)
      "Не все тесты уровня пройдены" unless satisfied?
    end
  end
end
