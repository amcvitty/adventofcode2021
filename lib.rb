require "matrix"
require "set"

def read_scanners
  lines = $stdin.read.split("\n")
  scanners = []
  scanner = nil
  lines.each do |line|
    if line.match(/scanner/)
      scanners << scanner if !scanner.nil?
      scanner = []
    elsif line == ""
    else
      x, y, z = line.split(",").map(&:to_i)
      scanner << Matrix.column_vector([x, y, z])
    end
  end
  scanners << scanner

  scanners
end

#Matrix[ [25, 93], [-1, 66] ]

# https://en.wikipedia.org/wiki/Rotation_matrix#In_three_dimensions
def rx(r)
  Matrix[
    [1, 0, 0],
    [0, cos(r), -sin(r)],
    [0, sin(r), cos(r)],
  ]
end

def ry(r)
  Matrix[
    [cos(r), 0, sin(r)],
    [0, 1, 0],
    [-sin(r), 0, cos(r)],
  ]
end

def rz(r)
  Matrix[
    [cos(r), -sin(r), 0],
    [sin(r), cos(r), 0],
    [0, 0, 1]
  ]
end

def sort_points(points)
  points.sort { |a, b|
    a[0, 0] <=> b[0, 0] ||
    a[1, 0] <=> b[1, 0] ||
    a[2, 0] <=> b[2, 0]
  }
end

def puts_points(points)
  sort_points(points).each { |a|
    puts "#{a[0, 0]},#{a[1, 0]},#{a[2, 0]}"
  }
end

def get_rotations
  angles = [0, Math::PI / 2, Math::PI, 3 * Math::PI / 2]
  xs = angles.map { |r| rx(r) }
  ys = angles.map { |r| ry(r) }
  zs = angles.map { |r| rz(r) }

  rots = Set[]

  xs.each do |x|
    ys.each do |y|
      zs.each do |z|
        rots << (x * y * z)
      end
    end
  end

  rots.to_a
end

# pre-calced version of the above
def get_rotations2
  [Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]],
   Matrix[[0, -1, 0], [1, 0, 0], [0, 0, 1]],
   Matrix[[-1, 0, 0], [0, -1, 0], [0, 0, 1]],
   Matrix[[0, 1, 0], [-1, 0, 0], [0, 0, 1]],
   Matrix[[0, 0, 1], [0, 1, 0], [-1, 0, 0]],
   Matrix[[0, 0, 1], [1, 0, 0], [0, 1, 0]],
   Matrix[[0, 0, 1], [0, -1, 0], [1, 0, 0]],
   Matrix[[0, 0, 1], [-1, 0, 0], [0, -1, 0]],
   Matrix[[-1, 0, 0], [0, 1, 0], [0, 0, -1]],
   Matrix[[0, 1, 0], [1, 0, 0], [0, 0, -1]],
   Matrix[[1, 0, 0], [0, -1, 0], [0, 0, -1]],
   Matrix[[0, -1, 0], [-1, 0, 0], [0, 0, -1]],
   Matrix[[0, 0, -1], [0, 1, 0], [1, 0, 0]],
   Matrix[[0, 0, -1], [1, 0, 0], [0, -1, 0]],
   Matrix[[0, 0, -1], [0, -1, 0], [-1, 0, 0]],
   Matrix[[0, 0, -1], [-1, 0, 0], [0, 1, 0]],
   Matrix[[1, 0, 0], [0, 0, -1], [0, 1, 0]],
   Matrix[[0, -1, 0], [0, 0, -1], [1, 0, 0]],
   Matrix[[-1, 0, 0], [0, 0, -1], [0, -1, 0]],
   Matrix[[0, 1, 0], [0, 0, -1], [-1, 0, 0]],
   Matrix[[-1, 0, 0], [0, 0, 1], [0, 1, 0]],
   Matrix[[0, 1, 0], [0, 0, 1], [1, 0, 0]],
   Matrix[[1, 0, 0], [0, 0, 1], [0, -1, 0]],
   Matrix[[0, -1, 0], [0, 0, 1], [-1, 0, 0]]]
end

def cos(angle)
  Math.cos(angle).round
end

def sin(angle)
  Math.sin(angle).round
end

def find_if_overlap(scanner, searching)
  get_rotations2.each_with_index do |rot, rn|
    s1 = searching.map { |p| rot * p }
    scanner.size.times do |i|
      s1.size.times do |j|
        disp = s1[j] - scanner[i]
        matches = scanner.intersection(s1.map { |p| p - disp })
        if matches.size >= 12
          puts "Rot #{rn} - #{i}, #{j}: #{matches.size}"
          # puts "Overlapping points:"
          # puts_points(matches)
          return [rot, disp]
        end
      end
    end
  end
  return nil
end

def manhattan_distance(a, b)
  (a[0, 0] - b[0, 0]).abs +
    (a[1, 0] - b[1, 0]).abs +
    (a[2, 0] - b[2, 0]).abs
end
