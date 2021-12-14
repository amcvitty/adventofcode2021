require_relative "lib.rb"
lines = $stdin.read.split("\n")

template = (lines.shift)

lines.shift

rules = lines.map { |l|
  pair, ins = /(\w\w) -> (\w)/.match(l).captures
  Rule.new(pair, ins)
}

puts template.to_s
puts rules.to_s

(1..10).each do |i|
  template = apply(template, rules)
  puts "After step #{i}: #{template.length}"
  puts score(template)
end
