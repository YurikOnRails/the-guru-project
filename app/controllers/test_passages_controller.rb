class TestPassagesController < ApplicationController
  include BadgesHelper
  before_action :authenticate_user!
  before_action :set_test_passage, only: %i[show update result]
  before_action :check_timer, only: %i[show update]

  def show; end

  def result
    if @test_passage.completed?
      @earned_badges = flash[:earned_badges] || []
    end
  end

  def update
    # Если пришел параметр time_out или время истекло, завершаем тест
    if params[:time_out] == 'true' || @test_passage.time_out?
      @test_passage.complete!
      redirect_to result_test_passage_path(@test_passage), alert: t('.time_out')
      return
    end

    @test_passage.accept!(params[:answer_ids])

    if @test_passage.completed?
      TestsMailer.completed_test(@test_passage).deliver_now
      result = BadgeService.new(@test_passage).call if @test_passage.successful?
      flash[:earned_badges] = result[:badges] if result

      notice = if !@test_passage.successful?
                 t('.failure')
               elsif result[:badges].present?
                 success_message(result[:badges])
               end

      alert_message = result[:errors].compact_blank.join(". ") if result
      flash[:alert] = alert_message if alert_message.present? && @test_passage.successful?

      redirect_to result_test_passage_path(@test_passage), notice: notice
    else
      render :show
    end
  end

  private

  def set_test_passage
    @test_passage = TestPassage.find(params[:id])
  end

  def check_timer
    if @test_passage.time_out?
      @test_passage.complete!
      redirect_to result_test_passage_path(@test_passage), alert: t('.time_out')
    end
  end

  def success_message(earned_badges)
    message = "Тест завершен."
    if earned_badges.present?
      message += " Вы получили #{earned_badges.count} #{badge_word(earned_badges.count)}!"
    end
    message
  end
end
