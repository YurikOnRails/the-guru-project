class BadgesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_badges = current_user.badges.distinct.order(:name)
    @user_badge_stats = current_user.user_badges
      .group(:badge_id)
      .count
  end
end 