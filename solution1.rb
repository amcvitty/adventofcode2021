data =
  STDIN.read
    .split("\n")
    .map(&:to_i)

prevsum = 9999999999
window = []
increases = 0
data.each do |num|
  window.shift if window.size == 3
  window.push num
  print "Window: #{window}, sum: #{window.sum}"
  if window.size == 3 && window.sum > prevsum
    increases += 1
    print " - Increase!"
  end
  prevsum = window.sum if window.size == 3

  puts
end
puts increases
