class TestPassagesController < ApplicationController
  before_action :set_test_result, only: %i[show update result]

  
  def show
  end

  def result
  end

  def update
    @test_result.accept!(params[:answer_ids])
    render :show
  end

  private

  def set_test_result
    @test_result = TestResult.find(params[:id])
  end

  def correct_answer?(answer_ids)
    correct_answers.count == correct_answers.where(id: answer_ids).count
  end

  def correct_answers
    current_question.answers.correct
  end
end
