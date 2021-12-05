data =
  STDIN.read
    .split("\n")

h = 0
d = 0
aim = 0
data.each do |line|
  (direction, amount) = line.split(" ")
  amount = amount.to_i
  case direction
  when "forward"
    h += amount
    d += aim * amount
  when "down"
    aim += amount
  when "up"
    aim -= amount
  else
    nil
  end
end
puts "Horizontal #{h}, Depth #{d}"
puts "product: #{h * d}"
