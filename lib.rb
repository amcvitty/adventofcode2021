require "set"
Point = Struct.new(:r, :c, :max_row, :max_col) do
  def adjacent_points
    p = []
    p << Point.new(r - 1, c, max_row, max_col) if r > 0
    p << Point.new(r + 1, c, max_row, max_col) if r < max_row
    p << Point.new(r, c - 1, max_row, max_col) if c > 0
    p << Point.new(r, c + 1, max_row, max_col) if c < max_col
    p
  end

  def inspect
    "(#{r}, #{c})"
  end
end

def basin(low_point, grid)
  explored = Set[]
  unexplored = Set[low_point]
  while unexplored.size > 0
    p = unexplored.to_a[0]
    p.adjacent_points.each do |a|
      if grid[a.r][a.c] >= grid[a.r][a.c] &&
         grid[a.r][a.c] != 9 &&
         !explored.include?(a) &&
         !unexplored.include?(a)
        unexplored << a
      end
      unexplored.delete p
      explored.add p
    end
  end
  explored
end

def print_grid_with_points(grid, points)
  max_row = grid.size - 1
  max_col = grid[0].size - 1
  (0..max_row).each do |r|
    (0..max_col).each do |c|
      if points.include?(Point.new(r, c, max_row, max_col))
        print grid[r][c], " "
      else
        print "  "
      end
    end
    puts
  end
end
