module ApplicationHelper
  def current_year
    Time.current.year
  end

  def github_url(author, repo)
    link_to "#{repo} on GitHub", "https://github.com/#{author}/#{repo}", target: "_blank"
  end

  def flash_message
    flash.map do |key, msg|
      content_tag :div, msg, class: "flash #{key}" if msg.present?
    end.join.html_safe
  end
end
