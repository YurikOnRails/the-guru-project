class Admin::AnswersController < Admin::BaseController
  before_action :set_question, only: [ :new, :create ]
  before_action :set_answer, only: [ :show, :edit, :update, :destroy ]

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to admin_test_path(@question.test), notice: "Ответ успешно создан"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @answer.update(answer_params)
      redirect_to admin_test_path(@answer.question.test), notice: "Ответ успешно обновлен"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    test = @answer.question.test
    @answer.destroy
    redirect_to admin_test_path(test), notice: "Ответ успешно удален"
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:content, :correct)
  end
end
