class TestsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_test_not_found

  before_action :authenticate_user!
  before_action :set_test, only: %i[show edit update destroy start]
  before_action :set_author, only: %i[new create]

  def index
    @tests = Test.all
  end

  def show; end

  def new
    @test = Test.new
  end

  def create
    @test = current_user.author_tests.new(test_params)

    if @test.save
      redirect_to @test, notice: "Test was successfully created."
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
    if @test.questions.empty?
      redirect_to tests_path, alert: "Test has no questions"
      return
    end

    @test_passage = current_user.test_passages.create!(test: @test)
    redirect_to @test_passage
  end

  private

  def set_test
    @test = Test.find(params[:id])
  end

  def set_author
    @author = User.first
  end

  def test_params
    params.require(:test).permit(:title, :level, :category_id)
  end

  def rescue_with_test_not_found
    render plain: "404: Тест не найден"
  end
end
