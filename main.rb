require_relative "lib.rb"
lines = $stdin.read.split("\n")
template = to_hashcount("x#{lines.shift}x")

lines.shift

rules = {}
lines.each { |l|
  pair, ins = /(\w\w) -> (\w)/.match(l).captures
  rules[pair] = ins
}

puts "x#{lines.shift}x".to_s
puts rules.to_s

(1..40).each do |i|
  template = apply(template, rules)
  puts "After step #{i}: #{template.length}"
  puts score(template)
end
