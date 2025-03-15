class TestsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_test_not_found

  def index
    @tests = Test.all
  end

  def show
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
  @test = current_user.author_tests.new
end

def create
  @test = current_user.author_tests.new(test_params)
  if @test.save
    redirect_to @test, notice: "Test successfully created!"
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
