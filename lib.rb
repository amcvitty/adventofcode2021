def parse_line(line)
  stack = []
  line.chars.each do |c|
    case c
    when "(", "[", "{", "<"
      stack.push c
    when ")", "}", "]", ">"
      if pair(stack.last) == c
        stack.pop
      else
        puts "Expected #{pair(stack.last)}, but found #{c} instead."
        return score(c)
      end
    end
  end
  return 0
end

def pair(c)
  case c
  when "("
    ")"
  when "["
    "]"
  when "{"
    "}"
  when "<"
    ">"
  end
end

def score(c)
  { ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137 }[c]
end
