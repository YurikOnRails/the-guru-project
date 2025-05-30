require_relative "base_rule"

module BadgeRules
  class CategoryCompleteRule < BaseRule
    def satisfied?
      category_id = @rule_value.to_i
      tests_in_category = Test.where(category_id: category_id).pluck(:id)
      passed_tests = @user.test_passages.successful.where(test_id: tests_in_category).pluck(:test_id).uniq
      (tests_in_category - passed_tests).empty?
    end

    def error_reason(_badge = nil)
      "Не все тесты категории пройдены" unless satisfied?
    end
  end
end
