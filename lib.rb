# Point = Struct.new(:x, :y)
def debug(x)
  puts x
end

Line = Struct.new(:x1, :y1, :x2, :y2) do
  def direction
    if x1 == x2
      :vertical
    elsif y1 == y2
      :horizontal
    else
      :other
    end
  end

  def vector
    if x1 == x2
      [0, (y2 - y1) / (y2 - y1).abs, (y2 - y1).abs]
    elsif y1 == y2
      [(x2 - x1) / (x2 - x1).abs, 0, (x2 - x1).abs]
    elsif (y1 - y2).abs == (x2 - x1).abs
      [(x2 - x1) / (x2 - x1).abs, (y2 - y1) / (y2 - y1).abs, (x2 - x1).abs]
    else
      throw "Not even!"
    end
  end
end

def parseline(str)
  p1, p2 = str.split(" -> ")
  x1, y1 = p1.split(",")
  x2, y2 = p2.split(",")
  Line.new(x1.to_i, y1.to_i, x2.to_i, y2.to_i)
end

class Board
  attr_accessor :board

  def initialize(x, y)
    self.board = []
    y.times {
      cba = []
      x.times { cba.push(0) }
      board.push cba
    }
  end

  def print
    board.map do |row|
      puts row.map { |d| d > 0 ? d : "." }.join(" ")
    end
  end

  def mark_point(x, y)
    # debug "marking #{x} #{y}"
    board[y][x] += 1
  end

  def get_point(x, y)
    board[y][x]
  end

  def draw(line)
    x1 = line.x1
    y1 = line.y1
    x, y, n = line.vector

    (n + 1).times do
      mark_point(x1, y1)
      x1 += x
      y1 += y
    end
    # if line.direction == :horizontal
    #   a, b = [line.x1, line.x2].sort
    #   (a..b).each { |x| mark_point(x, line.y1) }
    # elsif line.direction == :vertical
    #   a, b = [line.y1, line.y2].sort
    #   (a..b).each { |y| mark_point(line.x1, y) }
    # else
    # end
  end

  def count_danger_level(threshold)
    board.flatten.select { |x| x >= threshold }.size
  end
end
