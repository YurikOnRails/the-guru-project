class TestPassagesController < ApplicationController
  include BadgesHelper
  before_action :authenticate_user!
  before_action :set_test_passage, only: %i[show update result]

  def show; end

  def result
    if @test_passage.completed?
      @earned_badges = flash[:earned_badges] || []
    end
  end

  def update
    @test_passage.accept!(params[:answer_ids])

    if @test_passage.completed?
      TestsMailer.completed_test(@test_passage).deliver_now
      result = BadgeService.new(@test_passage).call
      flash[:earned_badges] = result[:badges]

      if !@test_passage.successful?
        notice = "Тест не пройден. Попробуйте ещё раз."
      elsif result[:badges].present?
        notice = success_message(result[:badges])
      else
        notice = nil
      end

      alert_message = result[:errors].compact_blank.join('. ')
      if alert_message.present? && @test_passage.successful?
        flash[:alert] = alert_message
      end

      redirect_to result_test_passage_path(@test_passage), notice: notice
    else
      render :show
    end
  end

  private

  def set_test_passage
    @test_passage = TestPassage.find(params[:id])
  end

  def success_message(earned_badges)
    message = "Тест завершен."
    if earned_badges.present?
      message += " Вы получили #{earned_badges.count} #{badge_word(earned_badges.count)}!"
    end
    message
  end
end
