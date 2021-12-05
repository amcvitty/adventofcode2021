realdata = $stdin.read.split("\n")

numbers = realdata[0].split(",").map(&:to_i)

def readline(data, index)
  data[index + 0].strip.split(/ +/).map(&:to_i)
end

def readboard(data, index)
  board = []
  board.push readline(data, index)
  board.push readline(data, index + 1)
  board.push readline(data, index + 2)
  board.push readline(data, index + 3)
  board.push readline(data, index + 4)
end

def gen_checkboard
  cb = []
  5.times {
    cba = []
    5.times { cba.push(false) }
    cb.push cba
  }
  cb
end

Board = Struct.new(:numbers, :checks) do
  def print
    puts (0..4).map { |r|
      (0..4).map { |c|
        sprintf("%2d", numbers[r][c]) << (checks[r][c] ? "x" : " ")
      }.join(", ")
    }.join("\n")
  end

  def mark(num)
    (0..4).map { |r|
      (0..4).map { |c|
        checks[r][c] = true if numbers[r][c] == num
      }
    }
  end

  def winning
    winning = false
    (0..4).each { |r|
      winning = true if checks[r].all?
    }
    (0..4).each { |c|
      winning = true if (0..4).map { |r| checks[r][c] }.all?
    }
    winning
  end

  def sum_unmarked
    sum = 0
    (0..4).each { |r|
      (0..4).each { |c|
        sum += numbers[r][c] unless checks[r][c]
      }
    }
    sum
  end
end

boards = []
line = 2
while line < realdata.size
  boards.push Board.new(readboard(realdata, line), gen_checkboard)
  line += 6
end

numbers.each do |num|
  boards.each_with_index do |board, index|
    board.mark(num)
    if board.winning
      puts "Board: #{index}"
      puts board.sum_unmarked
      puts "number: #{num}"
      puts board.sum_unmarked * num
      exit 0
    end
  end
end
