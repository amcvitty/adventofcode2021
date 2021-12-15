Point = Struct.new(:r, :c) do
  def inspect
    "#{r},#{c}"
  end
end

class Queue
  attr_accessor :max_row, :max_col, :dist, :visited

  def initialize(r, c, dist)
    self.max_row = r - 1
    self.max_col = c - 1
    self.dist = dist
    self.visited = Array.new(r) { Array.new(c, false) }
  end

  def extract_min()
    min = 9999999999
    min_point = nil
    (0..max_row).each { |r|
      (0..max_col).each { |c|
        if !visited[r][c] && dist[r][c] < min
          min = dist[r][c]
          min_point = Point.new(r, c)
        end
      }
    }
    visited[min_point.r][min_point.c] = true unless min_point.nil?
    min_point
  end
end

def adj(r, c, max_row, max_col)
  p = []
  # p << Point.new(r - 1, c - 1) if r > 0 && c > 0
  p << Point.new(r - 1, c) if r > 0
  # p << Point.new(r - 1, c + 1) if r > 0 && c < max_col
  p << Point.new(r, c - 1) if c > 0
  p << Point.new(r, c + 1) if c < max_col
  # p << Point.new(r + 1, c - 1) if r < max_row && c > 0
  p << Point.new(r + 1, c) if r < max_row
  # p << Point.new(r + 1, c + 1) if r < max_row && c < max_col
  p
end

def def_chain(pred, r, c)
  chain = [Point.new(r, c)]
  while !(r == 0 && c == 0)
    p = pred[r][c]
    chain << p
    r = p.r
    c = p.c
  end
  chain
end

# Rule = Struct.new(:pair, :ins) do
#   def inspect
#     "#{pair} => #{ins}"
#   end
# end

# def to_hashcount(str)
#   pairs = {}
#   (0..str.length - 2).each { |i|
#     pair = str[i, 2]
#     if pairs[pair]
#       pairs[pair] += 1
#     else
#       pairs[pair] = 1
#     end
#   }
#   pairs
# end

# def applyn(template, rules, n)
#   n.times do
#     template = apply(template, rules)
#   end
#   template
# end

# def apply(template, rules)
#   t2 = {}
#   template.each do |pair, freq|
#     ins = rules[pair]
#     if ins.nil?
#       add_to_key(t2, pair, freq)
#     else
#       add_to_key(t2, pair.chars[0] + ins, freq)
#       add_to_key(t2, ins + pair.chars[1], freq)
#     end
#   end
#   t2
# end

# def add_to_key(hash, k, v)
#   if hash[k]
#     hash[k] += v
#   else
#     hash[k] = v
#   end
# end

# def apply1(template, rules)
#   insertions = Array.new(template.length, nil)
#   (0..template.length - 2).each do |i|
#     rules.each do |rule|
#       if template[i, 2] == rule.pair
#         insertions[i] = rule.ins
#       end
#     end
#   end
#   t2 = ""
#   (0..template.length - 1).each do |i|
#     t2 << template[i]
#     t2 << insertions[i] if !insertions[i].nil?
#   end
#   t2
# end

# def score(template)
#   letter_frequencies = {}
#   template.each { |pair, f|
#     add_to_key(letter_frequencies, pair[0], f)
#     add_to_key(letter_frequencies, pair[1], f)
#   }
#   letter_frequencies.delete("x")
#   fs = letter_frequencies.values.map { |f| f / 2 }
#   fs.max - fs.min
# end
