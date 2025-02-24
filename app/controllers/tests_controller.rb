class TestsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_test_not_found

  def index
    result = [ "Class: #{params.class}", "Parameters: #{params.inspect}" ]

    render plain: result.join("\n")
  end

  def show
    title = Test.first.title

    render inline: "<%= @test.title %>"
  end

  def new
  end

  def create
    @test = Test.new(test_params)
    if @test.save
      render plain: "Test created successfully! ID: #{@test.id}, Title: #{@test.title}, Level: #{@test.level}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def test_params
    params.require(:test).permit(:title, :level)
  end


  def rescue_with_test_not_found
    render plain: "Test was not found"
  end
end
