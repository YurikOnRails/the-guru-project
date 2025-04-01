class TestPassagesController < ApplicationController
  before_action :set_test_passage, only: %i[show update result]
  before_action :set_user, only: %i[create]

  def show
  end

  def result
  end

  def create
    @test_passage = @user.test_passages.build(test_passage_params)

    if @test_passage.save
      redirect_to @test_passage, notice: 'Тест успешно начат'
    else
      redirect_to @test_passage.test, alert: 'Ошибка при создании теста'
    end
  end

  def update
    if @test_passage.accept!(params[:answer_ids])
      if @test_passage.completed?
        redirect_to result_test_passage_path(@test_passage)
      else
        render :show
      end
    else
      render :show
    end
  end

  private

  def set_test_passage
    @test_passage = TestPassage.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def test_passage_params
    params.require(:test_passage).permit(:test_id)
  end
end
