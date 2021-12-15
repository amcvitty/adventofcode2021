require_relative "lib.rb"
lines = $stdin.read.split("\n")

$vs = lines.map { |line| line.chars.map(&:to_i) }

puts $vs.map(&:to_s)
max_row = $vs.size - 1
max_col = $vs[0].size - 1

#### initialise single source(G, source)
# where G = (v,e) is actually
$dist = Array.new($vs.size) { Array.new($vs[0].size, 99999) }
$pred = Array.new($vs.size) { Array.new($vs[0].size, nil) }

# our source is 0,0
$dist[0][0] = 0

# u, v are Points in the graph
# w is weight of edge from u to v
def relax(u, v)
  puts "Relaxing #{u.inspect}, #{v.inspect}"
  puts "dist[v]: #{$dist[v.r][v.c]}, dist[u]: #{$dist[u.r][u.c]}, w: #{$vs[v.r][v.c]}"
  if $dist[v.r][v.c] > $dist[u.r][u.c] + $vs[v.r][v.c]
    puts "Setting #{$dist[u.r][u.c] + $vs[v.r][v.c]}"
    $dist[v.r][v.c] = $dist[u.r][u.c] + $vs[v.r][v.c]
    $pred[v.r][v.c] = u
  end
end

# this is S - the vertices that have been explored
explored = Array.new($vs.size) { Array.new($vs[0].size, false) }
# this is Q - "vertices in V - S keyed by their d values"
queue = Queue.new($vs.size, $vs[0].size, $dist)

u = queue.extract_min
puts u
while !u.nil?
  # 5.times do
  puts "Exploring (#{u.inspect})"
  explored[u.r][u.c] = true
  adj(u.r, u.c, max_row, max_col).each { |v|
    relax(u, v)
  }
  u = queue.extract_min
end

puts $dist.map(&:to_s)
puts "-----------------------------"

path = def_chain($pred, 8, 8)
puts path.reverse.map(&:inspect).join(" - ")
puts path.map { |p| $vs[p.r][p.c] }.sum
