require "matrix"
$verbose = false

def parse_lines(lines)
  lines.map do |line|
    d, x1, x2, y1, y2, z1, z2 = /(o\w+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/.match(line).captures
    x1, x2, y1, y2, z1, z2 = [x1, x2, y1, y2, z1, z2].map(&:to_i)
    [d, x1, x2, y1, y2, z1, z2]
  end
end

def limit(a, b)
  throw "not in order" if a > b
  if b < -50 or a > 50
    return 1..0
  else
    a = a > 50 ? 50 : (a < -50 ? -50 : a)
    b = b > 50 ? 50 : (b < -50 ? -50 : b)
    return a..b
  end
end
