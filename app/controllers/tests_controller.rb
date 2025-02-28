class TestsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_test_not_found

  def index
    # result = [ "Class: #{params.class}", "Parameters: #{params.inspect}" ]
    #
    # render plain: result.join("\n")
    @tests = Test.all
  end

  def show
    # title = Test.first.title

    # render inline: "<%= @test.title %>"
    @test = Test.find(params[:id])
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
  def new
    @test = Test.new
  end

  def create
    @test = Test.new(test_params)

    if @test.save
      redirect_to @test
    else
      render :new
    end
  end

  private

  def test_params
    params.require(:test).permit(:title, :level)
  end

  def test_params
    params.require(:test).permit(:title, :level, :category_id)
  end


  def rescue_with_test_not_found
    render plain: "Test was not found"
  end
end
