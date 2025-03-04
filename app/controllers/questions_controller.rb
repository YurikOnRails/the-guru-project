class QuestionsController < ApplicationController
  before_action :set_test, only: %i[index new create]
  before_action :set_question, only: %i[show edit update destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_question_not_found

  def index
    @questions = @test.questions
  end

  def show; end

  def new
    @question = @test.questions.new
  end

  def create
    @question = @test.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: "Question was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: "Question was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    redirect_to test_questions_path(@question.test), notice: "Question was deleted."
  end

  private

  def question_params
    params.require(:question).permit(:content)
  end

  def set_test
    @test = Test.find(params[:test_id])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def rescue_with_question_not_found
    render plain: "Question not found!", status: 404
  end
end
