require_relative "lib.rb"
lines = $stdin.read.split "\n"

directions = parse_lines(lines)
cubes = {}
directions.each do |d|
  d, x1, x2, y1, y2, z1, z2 = d
  limit(x1, x2).each do |x|
    limit(y1, y2).each do |y|
      limit(z1, z2).each do |z|
        unless x.abs > 50 || y.abs > 50 || z.abs > 50
          cubes[[x, y, z]] = (d == "on")
        end
      end
    end
  end
end
puts cubes.values.select(&:itself).size
