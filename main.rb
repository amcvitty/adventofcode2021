require_relative "lib.rb"
lines = $stdin.read.split("\n")
scores = lines.map { |line|
  parse_line(line)
}.select { |x| x > 0 }.sort

puts scores.to_s
puts "Middle: #{scores[scores.size / 2]}"
