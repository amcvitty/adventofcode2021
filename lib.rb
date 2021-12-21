require "matrix"
$verbose = true
# Uses a seed to generate an infinite stream of digits in the base provided
# Every seed will generate a different seed
class DiracDice
  def initialize(seed)
    @seed = seed
    @base = 10
  end

  def seed
    @seed
  end

  def roll
    return nil if @seed == 0
    r = @seed % @base
    @seed = @seed / @base
    r
  end
end

class DeterministicDice
  def initialize
    @i = 0
    @n = 100
  end

  def roll
    @i = @i % @n + 1
  end

  def seed
    "Deterministic:#{@n}"
  end
end

def play_game(dice, start_positions, target)
  puts "Playing game with #{dice.seed}" if $verbose
  rolls = 0
  positions = start_positions.map(&:itself)
  players = positions.size
  scores = Array.new(players, 0)
  loop do |round|
    players.times do |p|
      d = [dice.roll()]
      d << dice.roll()
      d << dice.roll()

      if d.any?(&:nil?)
        puts "No winner" if $verbose
        return nil
      end
      rolls += 3

      positions[p] = ((positions[p] + d.sum) - 1) % 10 + 1
      scores[p] += positions[p]
      if (scores[p] >= target)
        puts "Player #{p + 1}  rolls: #{d.map(&:to_s).join("+")}  position: #{positions[p]} score #{scores[p]}" if $verbose
        return Matrix[[(p + 1) % 2, p % 2]]
      end
    end
  end
end

def explore_games(seed, positions, target)
  result = play_game(DiracDice.new(seed), positions, target)
  if result.nil?
    explore_games(seed * 10 + 1, positions, target) +
      explore_games(seed * 10 + 2, positions, target) +
      explore_games(seed * 10 + 3, positions, target)
  else
    result
  end
end
