require_relative "lib.rb"

dist, prev = get_dist_prev
# puts dist[4].to_s
# puts prev[4].to_s
state = parse_stdin

# dump(state)
# dump(target)

# state = move(state, 5, 8)
# state = move(state, 3, 13)
# state = move(state, 4, 9)
# dump(state)

moves = valid_moves(state, dist, prev)
moves.each { |x| puts x }

#initialize
