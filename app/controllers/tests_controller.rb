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

    test = Test.create(params[:test])

    render plain: test.inspect
  end
end
