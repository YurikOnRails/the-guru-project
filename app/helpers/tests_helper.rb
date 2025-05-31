module TestsHelper
  LEVELS = %w[elementary intermediate advanced].freeze

  def level_description(level)
    LEVELS[level - 1] || "level #{level}"
  end

  def test_level(test)
    case test.level
    when 0
      t('.easy')
    when 1
      t('.elementary')
    when 2
      t('.intermediate')
    when 3
      t('.advanced')
    else
      t('.expert')
    end
  end
end
