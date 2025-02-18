class TestsController < ApplicationController
  def index
    result = [ "Class: #{params.class}", "Parameters: #{params.inspect}" ]

    render plain: result.join("\n")
  end

  def show
    redirect_to root_path
  end

  def new
  end

  def create
    test = Test.create(test_params)

    render plain: test.inspect
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]

    render plain: result.join("\n")
  end

  private

  def test_params
    params.require(:test).permit(:title, :level)
  end
end
