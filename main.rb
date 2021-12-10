require_relative "lib.rb"
lines = $stdin.read.split("\n")
grid = lines.map { |line|
  line.chars.map(&:to_i)
}

max_row = grid.size - 1
max_col = grid[0].size - 1
risk = 0
low_points = []
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
      low_points << Point.new(r, c, max_row, max_col)
    end
  end
end
print_grid_with_points(grid, low_points)
puts "-----"
puts "Part 1: "
puts "Risk: #{risk}"
puts low_points.to_s
puts "-----"
basin_sizes = low_points.map do |low_point|
  b = basin(low_point, grid)
  puts "Basin size: #{b.size}"
  print_grid_with_points(grid, b)
  puts "-----"
  b.size
end
puts basin_sizes.sort.reverse.take(3).reduce(&:*)
