require_relative "lib.rb"
lines = $stdin.read.split "\n"

result = lines.reduce(nil) { |grid, line|
  node = parse_line(line)
  puts line
  insert(node, grid)
}

puts count(result, "on")

# Example 3D with vizualization
# list = nil
# list = insert(Node.new(1..3, Node.new(1..9, Node.new(1..9, "."))), list)
# list = insert(Node.new(1..3, Node.new(4..6, Node.new(4..6, "X"))), list)
# list = insert(Node.new(2..3, Node.new(5..7, Node.new(5..7, "Z"))), list)
# puts list

# list.each { |x|
#   x.range.each { |_row|
#     x.val.each { |y|
#       y.range.each { |_c|
#         y.val.each { |z|
#           z.range.each { |_c|
#             print z.val
#           }
#         }
#         puts
#       }
#     }
#     puts "---"
#   }
# }
# puts count(list, "Z")
