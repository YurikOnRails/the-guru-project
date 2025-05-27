class TestPassagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_test_passage, only: %i[show update result]

  def show; end

  def result
    if @test_passage.completed?
      @earned_badges = Badge.where(id: flash.delete(:earned_badge_ids))
    end
  end

  def update
    @test_passage.accept!(params[:answer_ids])

    if @test_passage.completed?
      TestsMailer.completed_test(@test_passage).deliver_now
      earned_badges = BadgeService.new(@test_passage).call
      flash[:earned_badge_ids] = earned_badges.map(&:id)
      redirect_to result_test_passage_path(@test_passage), notice: success_message
    else
      render :show
    end
  end

  private

  def set_test_passage
    @test_passage = TestPassage.find(params[:id])
  end

  def success_message
    message = "Тест завершен."
    if @earned_badges.present?
      message += " Вы получили #{@earned_badges.count} " +
                "#{Russian.p(@earned_badges.count, 'бейдж', 'бейджа', 'бейджей')}!"
    end
    message
  end
end
