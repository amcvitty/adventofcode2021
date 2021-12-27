require_relative "lib.rb"

dist, prev = get_dist_prev
# puts dist.map(&:to_s)
# puts prev.map(&:to_s)

$initial_state = parse_stdin
#####
#
# # This was me debugging based on the example. I had a bug in the most recent bit of code I changed of course!
# state = $initial_state

# $prev = prev

# def do_move(state, i, j)
#   moves = valid_moves(state, $prev)
#   unless moves.any? { |m| m.from == i && m.to == j }
#     dump state
#     puts state[i]
#     puts get_home_move(state, $prev, i, true)
#     puts moves
#     throw "No move #{i}, #{j}"
#   end
#   move(state, i, j)
# end
#
# state = do_move(state, 15, 22)
# state = do_move(state, 14, 16)
# state = do_move(state, 11, 21)
# state = do_move(state, 10, 20)
# state = do_move(state, 9, 17)
# state = do_move(state, 7, 9)
# state = do_move(state, 6, 10)
# state = do_move(state, 5, 19)
# state = do_move(state, 4, 18)
# state = do_move(state, 19, 4)
# state = do_move(state, 20, 5)
# state = do_move(state, 21, 6)
# state = do_move(state, 13, 11)
# state = do_move(state, 12, 21)
# state = do_move(state, 18, 12)
# state = do_move(state, 3, 7)
# state = do_move(state, 2, 13)
# state = do_move(state, 1, 18)
# state = do_move(state, 17, 1)
# state = do_move(state, 16, 2)
# state = do_move(state, 18, 14)
# state = do_move(state, 21, 3)
# state = do_move(state, 22, 15)
# dump state
# exit
########

$energy_cost = {
  "A" => 1,
  "B" => 10,
  "C" => 100,
  "D" => 1000,
}

dump($initial_state)
dump($target)

puts dist.map(&:to_s)
puts "---"
puts prev.map(&:to_s)
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
queue = PQueue.new

# our source is out initial state
$energy[$initial_state] = 0
count = 0
u = $initial_state
while !u.nil? && u != $target
  count += 1
  puts "Count: #{count}, state = #{u}, energy= #{$energy[u]}" if count % 1000 == 0

  explored[u] = true
  valid_moves(u, prev).each { |move1|
    v = move(u, move1.from, move1.to)
    relax(u, v, $energy_cost[move1.m] * dist[move1.from][move1.to])
    if !explored[v]
      queue << PQVal.new(v, $energy[v])
    end
  }

  u = queue.extract_min
  u = u.val unless u.nil?
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
