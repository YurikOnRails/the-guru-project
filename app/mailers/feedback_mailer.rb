class FeedbackMailer < ApplicationMailer
  # Константа с email администратора
  ADMIN_EMAIL = "andrei.iurik@gmail.com"
  
  def feedback_email(feedback)
    @feedback = feedback
    
    # Используем заданный email администратора
    # Приоритет: переменная окружения > константа
    admin_email = ENV["ADMIN_EMAIL"] || ADMIN_EMAIL
    
    mail(
      to: admin_email,
      cc: Rails.env.development? ? @feedback.email : nil,
      subject: I18n.t("feedback_mailer.feedback_email.subject"),
      reply_to: @feedback.email
    )
  end
end
