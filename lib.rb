class PairParser
  attr_accessor :str, :i

  def initialize(str, i = 0)
    self.str = str
    self.i = 0
  end

  def parse
    if peek == "["
      @i += 1
      l = parse
      expect(",")
      r = parse
      expect("]")
      return Node.new(l, r)
    else
      val = read_val
      return Leaf.new(val.to_i)
    end
  end

  def peek
    str[i]
  end

  def read_char
    v = str[i]
    @i += 1
    v
  end

  def read_val
    v = 0
    while DIGITS.include? peek
      v = v * 10 + read_char.to_i
    end
    v
  end

  def expect(expected)
    c = read_char
    throw "Exendpected '#{expected}' but was '#{c}'" if c != expected
  end
end

class Node
  attr_reader :l, :r
  attr_accessor :parent

  def initialize(l, r)
    self.l = l
    self.r = r
  end

  def l=(node)
    @l = node
    node.parent = self
  end

  def r=(node)
    @r = node
    node.parent = self
  end

  def to_s
    "[#{l.to_s},#{r.to_s}]"
  end

  def is_leaf
    false
  end
end

class Leaf
  attr_accessor :val, :parent

  def initialize(val)
    self.val = val
  end

  def to_s
    val.to_s
  end

  def is_leaf
    true
  end
end

def closest_left(n)
  while n == n.parent.l
    n = n.parent
    return nil if n.parent == nil
  end

  # n is now the right node of a pair

  n = n.parent.l
  while !n.is_leaf
    n = n.r
  end
  n
end

def closest_right(n)
  while n == n.parent.r
    n = n.parent
    return nil if n.parent == nil
  end

  # n is now the left node of a pair

  n = n.parent.r
  while !n.is_leaf
    n = n.l
  end
  n
end

def explode(pair)
  explode_n(pair, 0)
end

def explode_n(pair, depth)
  if pair.is_leaf
    return false
  end

  if depth > 3
    explode_node(pair)
    return true
  end

  return explode_n(pair.l, depth + 1) || explode_n(pair.r, depth + 1)
end

def explode_node(n)
  cl = closest_left(n.l)
  cl.val += n.l.val unless cl.nil?

  cr = closest_right(n.r)
  cr.val += n.r.val unless cr.nil?

  if n == n.parent.l
    n.parent.l = Leaf.new(0)
  elsif n == n.parent.r
    n.parent.r = Leaf.new(0)
  else
    throw("Orphan?")
  end
end

def split_pair(pair)
  if pair.is_leaf
    if pair.val < 10
      return false
    else
      split_leaf pair
      return true
    end
  else
    return split_pair(pair.l) || split_pair(pair.r)
  end
end

def split_leaf(leaf)
  l = leaf.val / 2
  r = leaf.val.odd? ? (leaf.val + 1) / 2 : leaf.val / 2
  node = Node.new(
    Leaf.new(l),
    Leaf.new(r)
  )
  if leaf.parent.l == leaf
    leaf.parent.l = node
  else
    leaf.parent.r = node
  end
end

DIGITS = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

def add(pair1, pair2)
  pair = Node.new(pair1, pair2)
  while explode(pair) || split_pair(pair)
  end
  pair
end

def magnitude(pair)
  if pair.is_leaf
    return pair.val
  else
    return 3 * magnitude(pair.l) + 2 * magnitude(pair.r)
  end
end
