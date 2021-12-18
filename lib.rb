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
      val = read_char
      return Leaf.new(val.to_i)
    end
  end

  # version = read_digits(3)
  # type_id = read_digits(3)
  # if type_id == 4
  #   literal = read_literal
  #   return [version, type_id, literal]
  # else
  #   length_type_id = read_digits(1)
  #   if length_type_id == 0
  #     # length is a 15-bit number - number of bits in the sub-packets.
  #     length = read_digits(15)
  #     max_length = i + length
  #     packets = []
  #     while i < max_length
  #       packets << parse
  #     end
  #     return [version, type_id, packets]
  #   else
  #     # length is a 11-bit number -  sub-packets immediately contained by this packet.
  #     packets_to_read = read_digits(11)
  #     packets = []
  #     packets_to_read.times do
  #       packets << parse
  #     end
  #     return [version, type_id, packets]
  #   end
  # end

  def peek
    str[i]
  end

  def read_char
    v = str[i]
    @i += 1
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
