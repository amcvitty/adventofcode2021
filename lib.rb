def px(points)
  max_x = points.map(&:x).max
  max_y = points.map(&:y).max

  (0..max_y).each do |y|
    (0..max_x).each do |x|
      if points.include? Point.new(x, y)
        print "#"
      else
        print " "
      end
    end
    puts
  end
end

def fold(points, fold)
  n = fold.n
  points.map { |p|
    if fold.axis == "y"
      Point.new(p.x, p.y < n ? p.y : n - (p.y - n))
    else
      Point.new(p.x < n ? p.x : n - (p.x - n), p.y)
    end
  }.uniq
end
