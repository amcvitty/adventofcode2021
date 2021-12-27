require_relative "lib.rb"
lines = $stdin.read.split("\n")

$vs = lines.map { |line| line.chars.map(&:to_i) }
$vs = explode_graph($vs, 5)

max_row = $vs.size - 1
max_col = $vs[0].size - 1

puts "Total squares: #{$vs.size * $vs.size}"
#### initialise single source(G, source)
# where G = (v,e) is actually
$dist = Array.new($vs.size) { Array.new($vs[0].size, 99999) }
$pred = Array.new($vs.size) { Array.new($vs[0].size, nil) }

# u, v are Points in the graph
# w is weight of edge from u to v
def relax(u, v)
  if $dist[v.r][v.c] > $dist[u.r][u.c] + $vs[v.r][v.c]
    $dist[v.r][v.c] = $dist[u.r][u.c] + $vs[v.r][v.c]
    $pred[v.r][v.c] = u
  end
end

# this is S - the vertices that have been explored
explored = Array.new($vs.size) { Array.new($vs[0].size, false) }
# this is Q - "vertices in V - S keyed by their d values"
queue = Queue.new($dist)

# our source is 0,0
$dist[0][0] = 0
u = Point.new(0, 0)
count = 0
while !u.nil?
  explored[u.r][u.c] = true
  adj(u.r, u.c, max_row, max_col).each { |v|
    relax(u, v)
    if !explored[v.r][v.c]
      queue.add(v)
    end
  }
  count += 1
  # puts "Count: #{count}" if count % 1024 == 0
  u = queue.extract_min
end

puts $dist[max_row][max_col]
