data = $stdin.read.split("\n")

counts = []
data[0].split("").size.times { counts.push(0) }
data.each do |line|
  nums = line.split("")
  nums.each_with_index { |num, index|
    counts[index] += num.to_i
  }
end

print "epsilon: "
epsilon = 0
counts.each_with_index { |num, index|
  digit = (if num > data.size / 2
    0
  else
    1
  end)
  epsilon = epsilon * 2 + digit
  print digit
}
puts
puts epsilon

print "gamma: "
gamma = 0
counts.each_with_index { |num, index|
  digit = (if num < data.size / 2
    0
  else
    1
  end)
  gamma = gamma * 2 + digit
  print digit
}
puts
puts gamma

puts "Power consumption: #{gamma * epsilon}"
