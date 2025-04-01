class QuestionsController < ApplicationController
  before_action :set_test, only: %i[new create]
  before_action :set_question, only: %i[show edit update destroy]

  def show
  end

  def new
    @question = @test.questions.new
  end

  def create
    @question = @test.questions.new(question_params)
    if @question.save
      redirect_to @test, notice: "Question was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to @question.test, notice: "Question was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @test = @question.test
    @question.answers.destroy_all
    @question.destroy
    redirect_to @test, notice: "Question was successfully deleted."
  end

  private

  def set_test
    @test = Test.find(params[:test_id])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:content)
  end
end
