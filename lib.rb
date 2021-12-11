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
        return 0
      end
    end
  end

  remaining = stack.map { |c| pair(c) }
  print remaining.reverse.join("")
  s = score(remaining)
  print " - "
  print s
  puts
  s
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

# chars is an array that when reversed, completes
# the line
def score(chars)
  sum = 0
  while chars.size > 0
    sum *= 5
    sum += { ")" => 1,
             "]" => 2,
             "}" => 3,
             ">" => 4 }[chars.pop]
  end
  sum
end
