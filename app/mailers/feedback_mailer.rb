class FeedbackMailer < ApplicationMailer
  def feedback_email(feedback)
    @feedback = feedback
    # Получаем email администратора из кеша или из базы данных
    admin_email = Rails.cache.fetch("admin_email", expires_in: 1.hour) do
      Admin.first&.email
    end || "admin@example.com"

    mail(
      to: admin_email,
      subject: I18n.t("feedback_mailer.feedback_email.subject"),
      reply_to: @feedback.email
    )
  end
end
