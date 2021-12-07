require_relative "lib.rb"
ages = $stdin.read.split(",").map(&:to_i)

state = count_by_age(ages)
puts state.to_s

256.times do
  state = iterate(state)
  puts state.to_s
end
puts
puts "Fish count: #{state.sum}"
