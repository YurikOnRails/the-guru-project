class AnswersController < ApplicationController
  before_action :set_answer, only: %i[show edit update destroy]
  before_action :set_question, only: %i[new create]

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to admin_test_path(@question.test), notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @answer.update(answer_params)
      redirect_to admin_test_path(@answer.question.test), notice: t(".success_update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @test = @answer.question.test
    @answer.destroy
    redirect_to admin_test_path(@test), notice: t(".success_delete")
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:content, :correct)
  end
end
