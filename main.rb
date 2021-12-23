require_relative "lib.rb"
# lines = $stdin.read.split "\n"

# directions = parse_lines(lines)

# result = directions.reduce(nil) { |grid, node| insert(node, grid) }

list = nil
list = insert(Node.new(1..3, Node.new(1..9, Node.new(1..9, "."))), list)
list = insert(Node.new(1..3, Node.new(4..6, Node.new(4..6, "X"))), list)
list = insert(Node.new(2..3, Node.new(5..7, Node.new(5..7, "Z"))), list)
puts list

list.each { |x|
  x.range.each { |_row|
    x.val.each { |y|
      y.range.each { |_c|
        y.val.each { |z|
          z.range.each { |_c|
            print z.val
          }
        }
        puts
      }
    }
    puts "---"
  }
}
