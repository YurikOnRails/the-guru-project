class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    
    if @feedback.valid?
      begin
        FeedbackMailer.feedback_email(@feedback).deliver_now
        redirect_to root_path, notice: t("feedback.create.success")
      rescue => e
        Rails.logger.error("Ошибка отправки письма: #{e.message}")
        redirect_to new_feedback_path, alert: t("feedback.create.error")
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :email, :message)
  end
end
