class TestsController < ApplicationController
  before_action :set_user
  before_action :set_test, only: :start

  def index
    @tests = Test.all
  end

  def show
    @test = Test.find(params[:id])
  end

  def new
    @test = @user.author_tests.new
  end

  def create
    @test = @user.author_tests.new(test_params)
    if @test.save
      redirect_to @test, notice: "Test successfully created!"
    else
      render :new
    end
  end

  def edit
    @test = Test.find(params[:id])
  end

  def update
    @test = Test.find(params[:id])
    if @test.update(test_params)
      redirect_to @test
    else
      render :edit
    end
  end

  def destroy
    @test = Test.find(params[:id])
    @test.destroy
    redirect_to tests_path
  end

  def start
    if @test.questions.empty?
      redirect_to tests_path, alert: 'Тест не содержит вопросов'
      return
    end

    test_passage = @user.test_passages.create!(test: @test)
    redirect_to test_passage_path(test_passage)
  end

  private

  def set_user
    @user = User.first # Заглушка: всегда используем первого пользователя
  end

  def set_test
    @test = Test.find(params[:id])
  end

  def test_params
    params.require(:test).permit(:title, :level, :category_id)
  end
end
