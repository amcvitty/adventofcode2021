require_relative "lib.rb"
positions = $stdin.read.split(",").map(&:to_i)

max_pos = positions.max
min_pos = positions.min

solutions = []
(min_pos..max_pos).each do |target|
  fuel = 0
  positions.each do |pos|
    fuel += fuel_for((pos - target).abs)
  end
  solutions << fuel
end

puts solutions.min
