require_relative "lib.rb"
lines = $stdin.read.split("\n")

grid = lines.map { |line|
  line.chars.map(&:to_i)
}

puts grid.map(&:to_s)
putsline

max_row = grid.size - 1
max_col = grid[0].size - 1
i = 0
while count_flashes(grid) < 100
  i += 1
  to_flash = Set[]
  (0..max_row).each { |r|
    (0..max_col).each { |c|
      grid[r][c] += 1
      if grid[r][c] > 9
        to_flash << Point.new(r, c)
      end
    }
  }

  while !to_flash.empty?
    flashing = to_flash.to_a[0]
    to_flash.delete flashing
    adjacent_points(flashing.r, flashing.c, max_row, max_col).each { |p|
      # Will only be 0 if it's flashed already
      if grid[p.r][p.c] != 0
        grid[p.r][p.c] += 1
        if grid[p.r][p.c] > 9
          # no need to check if it's in to_flash because it's a set
          to_flash << Point.new(p.r, p.c)
        end
      end
    }
    grid[flashing.r][flashing.c] = 0
  end
  flashes = count_flashes(grid)
  puts "Flashes(#{i}): #{flashes}"
end
