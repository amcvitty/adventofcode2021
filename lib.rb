require "matrix"
$verbose = false

List = Struct.new(:hd, :tail) do
  def to_s
    if tail
      "#{hd},#{tail}"
    else
      hd.to_s
    end
  end

  def ==(other)
    if other.nil? || other.hd != hd
      false
    else
      tail == other.tail
    end
  end

  def size
    1 + (tail.nil? ? 0 : tail.size)
  end
end

def cons(a, as)
  List.new(a, as)
end

Node = Struct.new(:range, :direction) do
  def to_s
    "#{range}:#{direction}"
  end

  def +(other)
    cons(self, other)
  end
end

def insert(b, list)
  if list.nil?
    return cons(b, nil)
  end

  # Crucial that b's direction overwrites a here
  a = list.hd
  ra = a.range
  rb = b.range
  if ra.last < rb.first
    cons a, insert(b, list.tail)
  elsif ra.first > rb.last
    cons b, list
  elsif rb.cover?(ra)
    cons b, list.tail
  elsif rb.first <= ra.first && rb.last < ra.last
    cons b, cons(Node.new(rb.last + 1..ra.last, a.direction), list.tail)
  elsif rb.first > ra.first && rb.last < ra.last
    cons(Node.new(ra.first..rb.first - 1, a.direction),
         cons(b,
              cons(Node.new(rb.last + 1..ra.last, a.direction),
                   list.tail)))
  elsif rb.first > ra.first && rb.last >= ra.last
    cons(Node.new(ra.first..rb.first - 1, a.direction),
         insert(b, list.tail))
  else
    throw "Didn't find option for #{ra}, #{rb}"
  end
end

# Square = Struct.new(:x1, :x2, :y1, :y2) do
#   def contains?(x, y)
#     (x1..x2).include?(x) && (y1..y2).include?(y)
#   end

#   def overlaps?(s)
#     s.contains?(x1, y1) || s.contains?(x1, y2) ||
#     s.contains?(x2, y1) || s.contains?(x2, y2) ||
#     contains?(s.x1, s.y1) || contains?(s.x1, s.y2) ||
#     contains?(s.x2, s.y1) || contains?(s.x2, s.y2)
#   end
# end

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
