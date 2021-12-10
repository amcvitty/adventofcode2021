require_relative "lib.rb"
lines = $stdin.read.split("\n")
puts lines.map { |line|
  s = parse_line line
  puts s
  s
}.sum
