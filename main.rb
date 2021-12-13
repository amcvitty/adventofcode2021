require_relative "lib.rb"
lines = $stdin.read.split("\n")

Point = Struct.new(:x, :y) do
  def inspect
    "#{x},#{y}"
  end
end
Fold = Struct.new(:axis, :n)

coords = true
points = []
folds = []
lines.each do |line|
  if line == ""
    coords = false
  elsif coords
    x, y = line.split(",").map(&:to_i)
    points << Point.new(x, y)
  else
    axis, n = /fold along (x|y)=(\d+)/.match(line).captures
    folds << Fold.new(axis, n.to_i)
  end
end
points.sort_by! { |p| [p.x, p.y] }

puts points.to_s
puts folds.to_s

folds.each do |f|
  points = fold(points, f)
  # puts points.to_s
  # puts "Points visible: : #{points.size}"
end

px(points)

# points = fold(points, folds[1])
# puts points.to_s
# puts "Points visible: : #{points.size}"
# px(points)
