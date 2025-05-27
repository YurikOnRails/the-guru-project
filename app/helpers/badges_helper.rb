module BadgesHelper
  def times_word(count)
    return 'раз' if (11..14).include?(count % 100)
    case count % 10
    when 1 then 'раз'
    when 2..4 then 'раза'
    else 'раз'
    end
  end
end 