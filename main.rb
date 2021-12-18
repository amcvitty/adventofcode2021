require_relative "lib.rb"

lines = $stdin.read.split("\n")

pairs = lines.map { |l| PairParser.new(l).parse }

# puts pairs.map(&:to_s)
result = pairs.reduce { |sum, pair|
  add(sum, pair)
}

puts result.to_s
puts "Part1: magnitude: #{magnitude(result)}"

max_mag = 0
lines.each_with_index do |line1, a|
  lines.each_with_index do |line2, b|
    if (a != b)
      pair1 = PairParser.new(line1).parse
      pair2 = PairParser.new(line2).parse
      pair = add(pair1, pair2)
      mag = magnitude(pair)
      max_mag = mag if mag > max_mag
    end
  end
end
puts "Part2 MAX: #{max_mag}"
