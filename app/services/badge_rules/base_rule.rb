module BadgeRules
  class BaseRule
    def initialize(test_passage, rule_value)
      @test_passage = test_passage
      @user = test_passage.user
      @rule_value = rule_value
    end

    def satisfied?
      raise NotImplementedError
    end

    def error_reason(_badge = nil)
      nil
    end
  end
end
