require_relative "lib.rb"
lines = $stdin.read.split("\n")

# $vs will store labels with each index
$vs = []
$unique = []
lines.each do |line|
  l1, l2 = line.split "-"
  if !$vs.include? l1
    $vs.push(l1)
    $unique.push(l1.downcase == l1)
  end
  if !$vs.include? l2
    $vs.push(l2)
    $unique.push(l2.downcase == l2)
  end
end

# Use adjacency matrix form
$edges = Array.new($vs.size) { Array.new($vs.size, false) }

lines.each do |line|
  l1, l2 = line.split "-"
  $edges[$vs.index(l1)][$vs.index(l2)] = true
  $edges[$vs.index(l2)][$vs.index(l1)] = true
end

# puts $vs.to_s
# puts $unique.to_s
# puts $edges.map(&:to_s)
# puts $edges[$vs.index("b")][$vs.index("b")]
$s_node = $vs.index("start")
$e_node = $vs.index("end")

def visit(path, bonus)
  node = path.hd
  if node == $e_node
    puts path.to_a.map { |n| $vs[n] }.join ","
  else
    $edges[node].each_with_index do |edge, i|
      if edge && (!$unique[i] || !path.include?(i))
        visit(path.cons(i), bonus)
      end
      if edge && bonus.nil? && $unique[i] && path.include?(i) && i != $s_node
        visit(path.cons(i), i)
      end
    end
  end
end

visit(List.new($s_node, nil), nil)
