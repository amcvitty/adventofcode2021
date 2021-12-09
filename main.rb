require_relative "lib.rb"
lines = $stdin.read.split("\n")
grid = lines.map { |line|
  line.chars.map(&:to_i)
}

max_row = grid.size - 1
max_col = grid[0].size - 1
risk = 0
(0..max_row).each do |r|
  (0..max_col).each do |c|
    lowest = true
    me = grid[r][c]
    lowest = false if r > 0 && grid[r - 1][c] <= me
    lowest = false if r < max_row && grid[r + 1][c] <= me
    lowest = false if c > 0 && grid[r][c - 1] <= me
    lowest = false if c < max_col && grid[r][c + 1] <= me
    if lowest
      risk += 1 + me
      print me, " "
    else
      print "  "
    end
  end
  puts
end
puts "Risk: #{risk}"
