require_relative "lib.rb"
# lines = $stdin.read.split "\n"

singles = [
  [0, 1],
  [2, 3],
  [4, 5],
  [6, 7],
  [8, 9],
  [13, 14],
]

doubles = [
  [9, 10],
  [10, 11],
  [11, 12],
  [12, 13],
]
NODES = 15
adj = Array.new(NODES) { Array.new(NODES, nil) }

NODES.times.each { |v1|
  NODES.times.each { |v2|
    if singles.any? { |s|
      (s[0] == v1 && s[1] == v2) ||
      (s[0] == v2 && s[1] == v1)
    }
      x = adj[v1]
      x[v2] = 1
    end

    if doubles.any? { |d| d[0] == v1 && d[1] == v2 || d[0] == v2 && d[1] == v1 }
      adj[v1][v2] = 2
    end
  }
}
puts adj.map(&:to_s)
