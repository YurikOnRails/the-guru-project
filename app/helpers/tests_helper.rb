module TestsHelper
  def level_description(level)
    case level
    when 1 then "elementary"
    when 2 then "intermediate"
    when 3 then "advanced"
    else "level #{level}"
    end
  end
end
