module TestsHelper
  LEVELS = %w[elementary intermediate advanced].freeze

  def level_description(level)
    LEVELS[level - 1] || "level #{level}"
  end

  def test_level(test)
    level_badge(test.level)
  end

  def level_badge(level)
    badge_class = case level
                 when 0
                   'bg-primary'
                 when 1
                   'bg-success'
                 when 2
                   'bg-warning text-dark'
                 when 3
                   'bg-danger'
                 else
                   'bg-dark'
                 end

    content_tag :span, level, class: "badge rounded-pill #{badge_class}"
  end
end
