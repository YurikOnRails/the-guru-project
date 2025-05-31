class Admin::TestsController < Admin::BaseController
  before_action :set_tests, only: %i[index update_inline]
  before_action :set_test, only: %i[show edit update destroy update_inline]

  def index
    @tests = Test.all
    @timer_settings = params[:timer_settings].present?
  end

  def show; end

  def new
    @test = Test.new
  end

  def create
    @test = current_user.author_tests.new(test_params)

    if @test.save
      redirect_to admin_test_path(@test), notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @test.update(test_params)
      redirect_to admin_test_path(@test), notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_inline
    if @test.update(test_params)
      redirect_to admin_tests_path, notice: t(".success")
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @test.destroy
    redirect_to admin_tests_path, notice: t(".success")
  end

  private

  def set_tests
    @tests = Test.all
  end

  def set_test
    @test = Test.find(params[:id])
  end

  def test_params
    params.require(:test).permit(:title, :level, :category_id, :timer_minutes)
  end
end
