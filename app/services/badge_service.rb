class BadgeService
  def initialize(test_passage)
    @test_passage = test_passage
    @user = test_passage.user
  end

  def call
    return { badges: [], errors: [ "Тест не пройден успешно" ] } unless @test_passage.successful?

    badges = []
    errors = []

    Badge.find_each do |badge|
      unless badge.award_condition_met?(@test_passage)
        errors << error_reason(badge)
        next
      end
      if @user.badges.include?(badge)
        errors << "Бейдж '#{badge.name}' уже выдан."
        next
      end
      badges << award_badge(badge)
    end

    { badges: badges, errors: errors.compact_blank }
  end

  private

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
