class QuestionsController < ApplicationController
  before_action :set_test, only: %i[index new create]
  before_action :set_question, only: %i[show destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_question_not_found

  def index
    @questions = @test.questions
    render plain: @questions.map(&:content).join("\n")
  end

  def show
    render plain: @question.content.to_s
  end

  def new
    @question = @test.questions.new
  end

  def create
    @question = @test.questions.new(question_params)
    if @question.save
      render plain: "Question created successfully! ID: #{@question.id}, Content: #{@question.content}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    render plain: "Question deleted successfully!"
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
