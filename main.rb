require_relative "lib.rb"
realdata = $stdin.read.split("\n")

lines = realdata.map(&method(:parseline))

board = Board.new(1000, 1000)
lines.each { |l| board.draw(l) }
board.print
puts
puts board.count_danger_level(2)

# realdata.each do |d|
#   print d
#   print " "
#   print parseline(d).vector
#   puts
# end
