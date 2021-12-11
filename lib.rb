require "set"

Point = Struct.new(:r, :c)

def inc(grid)
  grid = grid.each { |line|
    line.each_with_index {
      |_, i|
      line[i] += 1
    }
  }
end

def putsline
  puts "---------"
end

def adjacent_points(r, c, max_row, max_col)
  p = []
  p << Point.new(r - 1, c - 1) if r > 0 && c > 0
  p << Point.new(r - 1, c) if r > 0
  p << Point.new(r - 1, c + 1) if r > 0 && c < max_col
  p << Point.new(r, c - 1) if c > 0
  p << Point.new(r, c + 1) if c < max_col
  p << Point.new(r + 1, c - 1) if r < max_row && c > 0
  p << Point.new(r + 1, c) if r < max_row
  p << Point.new(r + 1, c + 1) if r < max_row && c < max_col
  p
end

def count_flashes(grid)
  flashes = 0
  max_row = grid.size - 1
  max_col = grid[0].size - 1
  (0..max_row).each { |r|
    (0..max_col).each { |c|
      if grid[r][c] == 0
        flashes += 1
      end
    }
  }
  flashes
end
