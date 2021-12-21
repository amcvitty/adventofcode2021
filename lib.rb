require "matrix"
$verbose = false
$target = 21

$memovals = {}

def get_wins_freq(positions, scores, indent)
  memoed = $memovals[[positions, scores]]
  return memoed unless memoed.nil?

  puts "#{" " * indent}Running get_wins_freq: #{positions}, #{scores}" if $verbose
  allwins = [0, 0]
  frequencies.each_with_index do |f, d|
    p1, p2 = positions
    s1, s2 = scores
    if f > 0
      p1 = ((p1 + d) - 1) % 10 + 1
      s1 += p1
      puts "#{d}: #{f} #{p1} #{s1}" if $verbose
      if s1 >= $target
        allwins = add(allwins, [f, 0])
      else
        # here we reverse the positions, scores and wins to reflect
        # player 2 is now going next
        wins = get_wins_freq([p2, p1], [s2, s1], indent + 1).reverse
        wins = multiply(wins, f)
        allwins = add(wins, allwins)
      end
    end
  end
  puts "#{positions}, #{scores}:  #{allwins}" if $verbose
  $memovals[[positions, scores]] = allwins
  allwins
end

def add(arr1, arr2)
  a1, b1 = arr1
  a2, b2 = arr2
  [a1 + a2, b1 + b2]
end

def multiply(arr, f)
  a, b = arr
  [a * f, b * f]
end

# Some code to calculate frequencies
def gen_frequencies
  f = Array.new(10, 0)
  (1..3).each do |a|
    (1..3).each do |b|
      (1..3).each do |c|
        f[a + b + c] += 1
      end
    end
  end
  f
end

# For three rolls of a D3, here are the frequencies of each result, 0-9
def frequencies
  [0, 0, 0, 1, 3, 6, 7, 6, 3, 1]
end

# def play_game(dice, start_positions, target)
#   puts "Playing game with #{dice.seed}" if $verbose
#   rolls = 0
#   positions = start_positions.map(&:itself)
#   players = positions.size
#   scores = Array.new(players, 0)
#   loop do |round|
#     players.times do |p|
#       d = [dice.roll()]
#       d << dice.roll()
#       d << dice.roll()

#       if d.any?(&:nil?)
#         puts "No winner" if $verbose
#         return nil
#       end
#       rolls += 3

#       positions[p] = ((positions[p] + d.sum) - 1) % 10 + 1
#       scores[p] += positions[p]
#       if (scores[p] >= target)
#         puts "Player #{p + 1}  rolls: #{d.map(&:to_s).join("+")}  position: #{positions[p]} score #{scores[p]}" if $verbose
#         return Matrix[[(p + 1) % 2, p % 2]]
#       end
#     end
#   end
# end

# def explore_games(seed, positions, target)
#   result = play_game(DiracDice.new(seed), positions, target)
#   if result.nil?
#     explore_games(seed * 10 + 1, positions, target) +
#       explore_games(seed * 10 + 2, positions, target) +
#       explore_games(seed * 10 + 3, positions, target)
#   else
#     result
#   end
# end
