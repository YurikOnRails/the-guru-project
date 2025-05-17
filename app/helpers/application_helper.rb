module ApplicationHelper
  def current_year
    Time.current.year
  end

  def github_url(author, repo)
    link_to "#{repo}", "https://github.com/#{author}/#{repo}", target: "_blank"
  end

  def flash_message
    flash.map do |key, msg|
      content_tag :div, msg, class: "flash #{key}" if msg.present?
    end.join.html_safe
  end

  def bootstrap_alert_class(key)
    case key.to_s
    when "notice", "success"
      "success"
    when "alert", "error", "danger"
      "danger"
    when "warning"
      "warning"
    else
      "info"
    end
  end

  # Возвращает полное наименование приложения с текущим годом,
  # используется в футере
  def full_title(page_title = "")
    base_title = "Тест Гуру"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

  # Возвращает путь к тестам в зависимости от роли пользователя
  def tests_path_for_user(user)
    user&.admin? ? admin_tests_path : tests_path
  end
end
