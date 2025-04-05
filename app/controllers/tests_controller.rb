class TestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_test, only: [:show, :start]

  def index
    @tests = Test.all
  end

  def show
  end

  def start
    if @test.questions.empty?
      redirect_to tests_path, alert: 'Тест не содержит вопросов'
      return
    end

    @test_passage = current_user.test_passages.create!(test: @test)
    redirect_to @test_passage
  end

  private

  def set_test
    @test = Test.find(params[:id])
  end
end 