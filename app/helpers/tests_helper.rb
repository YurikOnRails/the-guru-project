module TestsHelper
  LEVELS = %w[elementary intermediate advanced].freeze

  def level_description(level)
    LEVELS[level - 1] || "level #{level}"
  end
end
