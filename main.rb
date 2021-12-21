require_relative "lib.rb"

# # positions =
# puts play_game(DeterministicDice.new, [4, 8], 1000)

# # Part 1:
# puts play_game(DeterministicDice.new, [8, 5], 1000)

# pos = [4, 8]
# # puts play_game(DiracDice.new(1111111111), pos, 9)

# puts explore_games(0, pos, 21)

puts get_wins_freq([8, 5], [0, 0], 0)
