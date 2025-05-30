require_relative "first_try_rule"
require_relative "category_complete_rule"
require_relative "level_complete_rule"

module BadgeRules
  module Registry
    RULES = {
      "first_try" => FirstTryRule,
      "category_complete" => CategoryCompleteRule,
      "level_complete" => LevelCompleteRule
    }.freeze

    def self.for(rule_type)
      RULES[rule_type]
    end
  end
end
