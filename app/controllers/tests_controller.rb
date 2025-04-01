class TestsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_test_not_found

  before_action :set_test, only: %i[show edit update destroy]

  def index
    @tests = Test.all
  end

  def show; end

  def new
    @test = Test.new
  end

  def create
    @test = Test.new(test_params)
    @test.author_id = params[:author_id]

    if @test.save
      redirect_to @test, notice: "Test successfully created!"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @test.update(test_params)
      redirect_to @test
    else
      render :edit
    end
  end

  def destroy
    @test.destroy
    redirect_to tests_path
  end

  def start
    test = Test.find(params[:id])

    if test.questions.empty?
      redirect_to tests_path, alert: "Тест не содержит вопросов"
      return
    end

    @test_passage = TestPassage.create!(test: test)
    redirect_to @test_passage
  end

  private

  def set_test
    @test = Test.find(params[:id])
  end

  def test_params
    params.require(:test).permit(:title, :level, :category_id, :author_id)
  end

  def rescue_with_test_not_found
    render plain: "Test not found", status: :not_found
  end
end
