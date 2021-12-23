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

  def each(&block)
    block.call(hd)
    tail.each(&block) if tail
  end
end

def cons(a, as)
  List.new(a, as)
end

Node = Struct.new(:range, :val) do
  def to_s
    "#{range}:#{val}"
  end

  def +(other)
    cons(self, other)
  end
end

def insert(b, list)
  if list.nil?
    return cons(Node.new(b.range, merge(b.val, nil)), nil)
  end

  # Crucial that b's val overwrites a here
  a = list.hd
  ra = a.range
  rb = b.range

  nodes = [Node.new(rb.first..[ra.first - 1, rb.last].min, merge(b.val, nil)),
           Node.new([rb.first, ra.first].max..[rb.last, ra.last].min, merge(b.val, a.val)),
           Node.new(ra.first..[rb.first - 1, ra.last].min, a.val),
           Node.new([ra.first, rb.last + 1].max..ra.last, a.val)]
    .filter { |n| n.range.size > 0 }
    .sort! { |a, b| b.range.first <=> a.range.first }

  # portion of b that comes after a - need to insert because could be more overlap in tail
  unmerged = Node.new([rb.first, ra.last + 1].max..rb.last, b.val)
  ret = list.tail
  ret = insert(unmerged, list.tail) if unmerged.range.size > 0
  nodes.each do |n|
    ret = cons n, ret
  end
  ret
end

# B takes precendence here
def merge(b, a)
  if b.is_a?(String) || b.is_a?(Integer)
    b
  elsif b.is_a?(Node) && (a.is_a?(List) || a.nil?)
    insert(b, a)
  else
    throw "Unexpected types #{b.class} #{a.class}"
  end
end

def parse_lines(lines)
  lines.map do |line|
    parse_line(line)
  end
end

def parse_line(line)
  d, x1, x2, y1, y2, z1, z2 = /(o\w+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/.match(line).captures
  x1, x2, y1, y2, z1, z2 = [x1, x2, y1, y2, z1, z2].map(&:to_i)

  Node.new(x1..x2,
           Node.new(y1..y2,
                    Node.new(z1..z2, d)))
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

def count(list, val)
  sum = 0
  list.each { |x|
    x.val.each { |y|
      y.val.each { |z|
        # We now have a cuboid!
        if z.val == val
          sum += x.range.size * y.range.size * z.range.size
        end
      }
    }
  }
  sum
end
