class BadgeService
  def initialize(test_passage)
    @test_passage = test_passage
    @user = test_passage.user
  end

  def call
    return [] unless @test_passage.successful?

    Badge.find_each.filter_map do |badge|
      award_badge(badge) if badge.award_condition_met?(@test_passage)
    end
  end

  private

  def award_badge(badge)
    UserBadge.create(
      user: @user,
      badge: badge
    )
  end
end 