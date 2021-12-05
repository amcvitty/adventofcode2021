data = $stdin.read.split("\n").map do |line|
  line.split("").map(&:to_i)
end

def count(lines, index)
  c = [0, 0]
  lines.each { |arr|
    c[arr[index]] += 1
  }
  c
end

def filter_by_pos(lines, index, filter)
  lines.filter { |x| x[index] == filter }
end

def ogr(lines, index)
  if lines.size == 1
    lines[0]
  else
    (a, b) = count(lines, index)
    if b >= a
      ogr(filter_by_pos(lines, index, 1), index + 1)
    else
      ogr(filter_by_pos(lines, index, 0), index + 1)
    end
  end
end

def csr(lines, index)
  if lines.size == 1
    lines[0]
  else
    (a, b) = count(lines, index)
    if a <= b
      csr(filter_by_pos(lines, index, 0), index + 1)
    else
      csr(filter_by_pos(lines, index, 1), index + 1)
    end
  end
end

def arr_to_i(arr)
  i = 0
  arr.each { |digit| i = i * 2 + digit }
  i
end

o = ogr(data, 0)
c = csr(data, 0)
puts o.to_s
puts arr_to_i o
puts c.to_s
puts arr_to_i c

puts ((arr_to_i o) * (arr_to_i c))
# e = ((0..4).to_a.map { |i|
#   (a, b) = count(lines, i)
#   if a > b
#     0
#   else
#     1
#   end
# })
# puts e.to_s
# puts arr_to_i(e)
