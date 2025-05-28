class BadgeService
  def initialize(test_passage)
    @test_passage = test_passage
    @user = test_passage.user
  end

  def call
    ensure_universal_badge_exists
    return failure_result('Тест не пройден успешно') unless @test_passage.successful?

    badges, errors = process_badges
    { badges: badges, errors: errors.compact_blank }
  end

  private

  def ensure_universal_badge_exists
    return if Badge.exists?(rule_type: 'first_try', rule_value: 'any')

    Badge.create!(
      name: 'С первой попытки',
      image_url: 'https://cdn-icons-png.flaticon.com/512/2583/2583344.png',
      rule_type: 'first_try',
      rule_value: 'any'
    )
  end

  def failure_result(message)
    { badges: [], errors: [message] }
  end

  def process_badges
    badges = []
    errors = []

    Badge.find_each do |badge|
      if !badge.award_condition_met?(@test_passage)
        errors << error_reason(badge)
      elsif @user.badges.include?(badge)
        errors << "Бейдж '#{badge.name}' уже выдан."
      else
        badges << award_badge(badge)
      end
    end

    [badges, errors]
  end

  def award_badge(badge)
    @user.badges << badge
    badge
  end

  def error_reason(badge)
    case badge.rule_type.to_sym
    when :first_try
      unless badge.rule_value == @test_passage.test.id.to_s
        return "Бейдж '#{badge.name}': rule_value (#{badge.rule_value}) не совпадает с id теста (#{@test_passage.test.id})"
      end
      attempts = @user.test_passages.where(test: @test_passage.test).count
      if attempts > 1
        return "Бейдж '#{badge.name}': тест был пройден не с первой попытки (попыток: #{attempts})"
      end
    when :category_complete
      unless @test_passage.test.category.id.to_s == badge.rule_value
        return "Бейдж '#{badge.name}': rule_value (#{badge.rule_value}) не совпадает с id категории (#{@test_passage.test.category.id})"
      end
    when :level_complete
      unless @test_passage.test.level == badge.rule_value.to_i
        return "Бейдж '#{badge.name}': rule_value (#{badge.rule_value}) не совпадает с уровнем теста (#{@test_passage.test.level})"
      end
    end
    nil
  end
end
