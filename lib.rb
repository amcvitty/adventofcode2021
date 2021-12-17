require "set"

def b_to_i(binary)
  i = 0
  binary.chars.each do |c|
    i = (i << 1) + c.to_i
  end
  i
end

def vsum(packet)
  version, type, payload = packet
  if type == 4
    return version
  else
    return payload.map { |packet| vsum(packet) }.sum + version
  end
end

def evaluate(packet)
  version, type, payload = packet
  case type
  when 0 then payload.map { |packet| evaluate(packet) }.sum
  when 1 then payload.map { |packet| evaluate(packet) }.reduce(:*)
  when 2 then payload.map { |packet| evaluate(packet) }.min
  when 3 then payload.map { |packet| evaluate(packet) }.max
  when 4 then payload
  when 5 then evaluate(payload[0]) > evaluate(payload[1]) ? 1 : 0
  when 6 then evaluate(payload[0]) < evaluate(payload[1]) ? 1 : 0
  when 7 then evaluate(payload[0]) == evaluate(payload[1]) ? 1 : 0
  end
end

class PacketParser
  attr_accessor :binary, :i

  def initialize(hex_str, i = 0)
    self.binary = parse_hex(hex_str)
    self.i = 0
  end

  def parse
    version = read_digits(3)
    type_id = read_digits(3)
    if type_id == 4
      literal = read_literal
      return [version, type_id, literal]
    else
      length_type_id = read_digits(1)
      if length_type_id == 0
        # length is a 15-bit number - number of bits in the sub-packets.
        length = read_digits(15)
        max_length = i + length
        packets = []
        while i < max_length
          packets << parse
        end
        return [version, type_id, packets]
      else
        # length is a 11-bit number -  sub-packets immediately contained by this packet.
        packets_to_read = read_digits(11)
        packets = []
        packets_to_read.times do
          packets << parse
        end
        return [version, type_id, packets]
      end
    end
  end

  def read_digits(n)
    v = b_to_i binary[i, n]
    self.i += n
    v
  end

  def read_literal
    val = 0
    repeat = true
    while repeat
      repeat = (binary[i, 1] == "1")
      digit_bin = binary[i + 1, 4]
      digit = b_to_i digit_bin
      val = (val << 4) + digit
      self.i += 5
    end
    val
  end

  private

  def parse_hex(hex_str)
    hex_str.chars.map { |c|
      case c
      when "0" then "0000"
      when "1" then "0001"
      when "2" then "0010"
      when "3" then "0011"
      when "4" then "0100"
      when "5" then "0101"
      when "6" then "0110"
      when "7" then "0111"
      when "8" then "1000"
      when "9" then "1001"
      when "A" then "1010"
      when "B" then "1011"
      when "C" then "1100"
      when "D" then "1101"
      when "E" then "1110"
      when "F" then "1111"
      end
    }.join ""
  end
end

# Point = Struct.new(:r, :c) do
#   def to_s
#     "#{r},#{c}"
#   end
# end

# # Actually supposed to be a priority queue
# class Queue
#   attr_accessor :points, :dist

#   def initialize(dist)
#     self.points = Set[]
#     self.dist = dist
#   end

#   def extract_min()toS
#     p = points.min_by { |v|
#       dist[v.r][v.c]
#     }
#     points.delete(p)
#     p
#   end

#   def add(p)
#     points.add(p)
#   end
# end

# def adj(r, c, max_row, max_col)
#   p = []
#   # p << Point.new(r - 1, c - 1) if r > 0 && c > 0
#   p << Point.new(r - 1, c) if r > 0
#   # p << Point.new(r - 1, c + 1) if r > 0 && c < max_col
#   p << Point.new(r, c - 1) if c > 0
#   p << Point.new(r, c + 1) if c < max_col
#   # p << Point.new(r + 1, c - 1) if r < max_row && c > 0
#   p << Point.new(r + 1, c) if r < max_row
#   # p << Point.new(r + 1, c + 1) if r < max_row && c < max_col
#   p
# end

# def def_chain(pred, r, c)
#   chain = [Point.new(r, c)]
#   while !(r == 0 && c == 0)
#     p = pred[r][c]
#     chain << p
#     r = p.r
#     c = p.c
#   end
#   chain
# end

# def explode_graph(vs, x)
#   vs2 = Array.new(vs.size * x) { Array.new(vs.size * x, 0) }
#   (0..x - 1).each { |r_adj|
#     (0..x - 1).each { |c_adj|
#       vs.each_with_index { |row, orig_r|
#         row.each_with_index { |orig_value, orig_c|
#           vs2[r_adj * vs.size + orig_r][c_adj * vs.size + orig_c] = wrap(orig_value + r_adj + c_adj)
#         }
#       }
#     }
#   }
#   vs2
# end

# def wrap(n)
#   (n - 1) % 9 + 1
# end

# # Rule = Struct.new(:pair, :ins) do
# #   def inspect
# #     "#{pair} => #{ins}"
# #   end
# # end

# # def to_hashcount(str)
# #   pairs = {}
# #   (0..str.length - 2).each { |i|
# #     pair = str[i, 2]
# #     if pairs[pair]
# #       pairs[pair] += 1
# #     else
# #       pairs[pair] = 1
# #     end
# #   }
# #   pairs
# # end

# # def applyn(template, rules, n)
# #   n.times do
# #     template = apply(template, rules)
# #   end
# #   template
# # end

# # def apply(template, rules)
# #   t2 = {}
# #   template.each do |pair, freq|
# #     ins = rules[pair]
# #     if ins.nil?
# #       add_to_key(t2, pair, freq)
# #     else
# #       add_to_key(t2, pair.chars[0] + ins, freq)
# #       add_to_key(t2, ins + pair.chars[1], freq)
# #     end
# #   end
# #   t2
# # end

# # def add_to_key(hash, k, v)
# #   if hash[k]
# #     hash[k] += v
# #   else
# #     hash[k] = v
# #   end
# # end

# # def apply1(template, rules)
# #   insertions = Array.new(template.length, nil)
# #   (0..template.length - 2).each do |i|
# #     rules.each do |rule|
# #       if template[i, 2] == rule.pair
# #         insertions[i] = rule.ins
# #       end
# #     end
# #   end
# #   t2 = ""
# #   (0..template.length - 1).each do |i|
# #     t2 << template[i]
# #     t2 << insertions[i] if !insertions[i].nil?
# #   end
# #   t2
# # end

# # def score(template)
# #   letter_frequencies = {}
# #   template.each { |pair, f|
# #     add_to_key(letter_frequencies, pair[0], f)
# #     add_to_key(letter_frequencies, pair[1], f)
# #   }
# #   letter_frequencies.delete("x")
# #   fs = letter_frequencies.values.map { |f| f / 2 }
# #   fs.max - fs.min
# # end
