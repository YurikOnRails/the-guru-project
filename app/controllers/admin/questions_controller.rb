class Admin::QuestionsController < Admin::BaseController
  before_action :set_test, only: [:new, :create]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  
  def show
  end
  
  def new
    @question = @test.questions.new
  end
  
  def create
    @question = @test.questions.new(question_params)
    
    if @question.save
      redirect_to admin_test_path(@test), notice: 'Вопрос успешно создан'
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @question.update(question_params)
      redirect_to admin_test_path(@question.test), notice: 'Вопрос успешно обновлен'
    else
      render :edit
    end
  end
  
  def destroy
    test = @question.test
    @question.answers.destroy_all # Сначала удаляем ответы
    @question.destroy
    redirect_to admin_test_path(test), notice: 'Вопрос успешно удален'
  end
  
  private
  
  def set_test
    @test = Test.find(params[:test_id])
  end
  
  def set_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:content)
  end
end 