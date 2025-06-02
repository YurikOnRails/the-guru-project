class TestPassagesController < ApplicationController
  include BadgesHelper
  before_action :authenticate_user!
  before_action :set_test_passage, only: %i[show update result]

  def show
    handle_completed_test || render
  end

  def result
    @earned_badges = flash[:earned_badges] || []
  end

  def update
    if @test_passage.completed?
      handle_completed_test
    else
      @test_passage.accept!(params[:answer_ids])
      
      if @test_passage.completed?
        process_completed_test
        redirect_to result_test_passage_path(@test_passage), flash: flash_options
      else
        render :show
      end
    end
  end

  private

  def set_test_passage
    @test_passage = TestPassage.find(params[:id])
  end

  def handle_completed_test
    return unless @test_passage.completed?

    @test_passage.complete!
    redirect_to result_test_passage_path(@test_passage), alert: t(".time_out")
  end

  def process_completed_test
    TestsMailer.completed_test(@test_passage).deliver_now
    @badge_result = BadgeService.new(@test_passage).call if @test_passage.successful?
    flash[:earned_badges] = @badge_result[:badges] if @badge_result
  end

  def flash_options
    messages = []
    messages << t(".failure") unless @test_passage.successful?
    messages << success_message(@badge_result[:badges]) if @test_passage.successful? && @badge_result&.dig(:badges)&.present?
    
    {
      notice: messages.compact.join(" "),
      alert: @badge_result&.dig(:errors)&.compact_blank&.join(". ")
    }.compact
  end

  def success_message(earned_badges)
    return unless earned_badges.present?

    "Тест завершен. Вы получили #{earned_badges.count} #{badge_word(earned_badges.count)}!"
  end
end
