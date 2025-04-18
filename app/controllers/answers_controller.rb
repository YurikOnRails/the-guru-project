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
      redirect_to @question.test, notice: "Answer was successfully created."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question.test, notice: "Answer was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @test = @answer.question.test
    @answer.destroy
    redirect_to @test, notice: "Answer was successfully deleted."
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
