class BadgeService
  def initialize(test_passage)
    @test_passage = test_passage
    @user = test_passage.user
  end

  def call
    ensure_universal_badge_exists
    return failure_result("Тест не пройден успешно") unless @test_passage.successful?

    badges, errors = process_badges
    { badges: badges, errors: errors.compact_blank }
  end

  private

  def ensure_universal_badge_exists
    return if Badge.exists?(rule_type: "first_try", rule_value: "any")

    Badge.create!(
      name: "С первой попытки",
      image_url: "https://cdn-icons-png.flaticon.com/512/2583/2583344.png",
      rule_type: "first_try",
      rule_value: "any"
    )
  end

  def failure_result(message)
    { badges: [], errors: [ message ] }
  end

  def process_badges
    badges = []
    errors = []

    Badge.find_each do |badge|
      rule_class = BadgeRules::Registry.for(badge.rule_type)
      if rule_class.nil?
        errors << "Неизвестное правило: #{badge.rule_type}"
        next
      end

      rule = rule_class.new(@test_passage, badge.rule_value)
      if !rule.satisfied?
        errors << rule.error_reason(badge)
      elsif @user.badges.include?(badge)
        errors << "Бейдж '#{badge.name}' уже выдан."
      else
        badges << award_badge(badge)
      end
    end

    [ badges, errors ]
  end

  def award_badge(badge)
    @user.badges << badge
    badge
  end
end
