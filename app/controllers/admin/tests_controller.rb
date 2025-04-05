class Admin::TestsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_test_not_found

  before_action :set_test, only: %i[start]
  before_action :set_author, only: %i[new create]

  def index
    @tests = Test.all
  end

  def start
      current_user.tests.push(@test)
      redirect_to current_user.test_passage(@test)
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

  def rescue_with_test_not_found
    render plain: "404: Тест не найден"
  end
end
