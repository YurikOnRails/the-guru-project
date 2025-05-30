require_relative "base_rule"

module BadgeRules
  class FirstTryRule < BaseRule
    def satisfied?
      @user.test_passages.where(test: @test_passage.test).count == 1
    end

    def error_reason(_badge = nil)
      "Тест был пройден не с первой попытки" unless satisfied?
    end
  end
end
