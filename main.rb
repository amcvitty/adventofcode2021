require_relative "lib.rb"

dist, prev = get_dist_prev
# puts dist[4].to_s
# puts prev[4].to_s
$initial_state = parse_stdin

$energy_cost = {
  "A" => 1,
  "B" => 10,
  "C" => 100,
  "D" => 1000,
}

# dump($initial_state)
# dump($target)
# exit

# puts dist[0]

# state = move(state, 5, 8)
# state = move(state, 3, 13)
# state = move(state, 4, 9)
# dump(state)

#### initialise single source(G, source)
# where G = (v,e) is actually
$energy = {}
$predecessor = {}

# u, v are Points in the graph
# w is weight of edge from u to v
def relax(u, v, w)
  if $energy[v].nil? || $energy[v] > $energy[u] + w
    $energy[v] = $energy[u] + w
    $predecessor[v] = u
  end
end

# this is S - the vertices that have been explored
explored = {}
# this is Q of things discovered but not explored, keyed by their energy cost
queue = Queue.new($energy)

# our source is out initial state
$energy[$initial_state] = 0
count = 0
u = $initial_state
while !u.nil? && u != $target
  count += 1
  puts "Count: #{count}, state = #{u}, energy= #{$energy[u]}" if count % 100 == 0

  explored[u] = true
  valid_moves(u, prev).each { |move1|
    v = move(u, move1.from, move1.to)
    relax(u, v, $energy_cost[move1.m] * dist[move1.from][move1.to])
    if !explored[v]
      queue.add(v)
    end
  }

  u = queue.extract_min
end

# Dump the answer
max_e = $target
turns = []
while max_e != nil
  turns << max_e
  max_e = $predecessor[max_e]
end

turns.reverse.each do |t|
  dump t

  puts "Energy: #{$energy[t]}"
end
puts "Moves: #{turns.size}"
