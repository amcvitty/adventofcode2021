require "pqueue"
require "set"

def get_adj_matrix

  # Mapping of places to numbers
  #############
  # 8 9   10   11   12   13 14#
  ##### 1 #  3 #  5 #  7 ######
  ##### 0 #  2 #  4 #  6 ######
  #############

  # Moves we can make
  singles = [
    [0, 1],
    [2, 3],
    [4, 5],
    [6, 7],
    [8, 9],
    [13, 14],
  ]

  # These pass through the nodes where we can't stop
  # at the top of each cave, so count for 2
  doubles = [
    [1, 9],
    [1, 10],
    [3, 10],
    [3, 11],
    [5, 11],
    [5, 12],
    [7, 12],
    [7, 13],
    [9, 10],
    [10, 11],
    [11, 12],
    [12, 13],
  ]
  nodes = 15
  adj = Array.new(nodes) { Array.new(nodes, nil) }

  nodes.times.each { |v1|
    nodes.times.each { |v2|
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

  adj
end

# Runs dijkstra's algo for numbered nodes
# 0..adj.size from source. Returns [dist[], prev[]]
def dijkstra(adj, source)
  v_count = adj.size
  dist = Array.new(v_count, 9999999)
  prev = Array.new(v_count, nil)
  q = Array.new(v_count) { |x| x }
  dist[source] = 0

  while q.size > 0
    # vertex in Q with min dist[u]
    u = q.min_by { |u| dist[u] }
    # remove u from Q
    q.reject! { |x| x == u }

    adj[u].each_with_index do |u_v, v|
      if !u_v.nil? && dist[v] > dist[u] + u_v
        dist[v] = dist[u] + u_v
        prev[v] = u
      end
    end
  end

  return [dist, prev]
end

# Get distance and prev arrays
# for each vertex
def get_dist_prev
  adj = get_adj_matrix

  dist = []
  prev = []

  adj.size.times { |v|
    di, pi = dijkstra(adj, v)
    dist << di
    prev << pi
  }
  [dist, prev]
end

def parse_stdin
  lines = $stdin.read.split "\n"

  pos = Array.new(15, nil)
  line1 = true
  lines.each do |line|
    m = /([A-D]).*([A-D]).*([A-D]).*([A-D]).*/.match(line)
    next unless m
    if line1
      pos[1], pos[3], pos[5], pos[7] = m.captures
      line1 = false
    else
      pos[0], pos[2], pos[4], pos[6] = m.captures
    end
  end
  return pos
end

def dump(state)
  puts "#############"
  puts "##{state[8] || "."}#{state[9] || "."}.#{state[10] || "."}.#{state[11] || "."}.#{state[12] || "."}.#{state[13] || "."}#{state[14] || "."}#"
  puts "####{state[1] || "."}##{state[3] || "."}##{state[5] || "."}##{state[7] || "."}###"
  puts "  ##{state[0] || "."}##{state[2] || "."}##{state[4] || "."}##{state[6] || "."}#"
  puts "  #########"
end

def blocked(state, prev, i, j)
  # puts "Checking blocked: #{i} => #{j}"
  loop do
    if i == j
      return false
    end
    if !state[j].nil?
      return true
    end
    j = prev[i][j]
  end
  throw "No path found!"
end

def move(state, i, j)
  ret = state.map(&:itself)
  ret[j] = state[i]
  ret[i] = nil
  ret
end

$target = ["A", "A", "B", "B", "C", "C", "D", "D",
           nil, nil, nil, nil, nil, nil, nil]

$home = {
  "A" => [0, 1],
  "B" => [2, 3],
  "C" => [4, 5],
  "D" => [6, 7],
}

def valid_moves(state, prev)
  moves = []
  15.times do |i|
    next unless state[i]
    if $target[i] == state[i]
      # We're in the right cave
      if i % 2 == 0
        # At the bottom
        next
      else
        # at the top, check the bottom too!
        next if $target[i - 1] == state[i - 1]
      end
    end
    if i < 8
      # in a cave
      if i % 2 == 0
        # trapped by one above (wee optimisation)
        next unless state[i + 1].nil?
      end

      # If we can go home in one move, do
      homes = $home[state[i]]
      if state[homes[0]].nil?
        moves << Move.new(state[i], i, homes[0]) unless blocked(state, prev, i, homes[0])
        next
      elsif state[homes[1]].nil?
        next unless state[i] == state[homes[0]]
        moves << Move.new(state[i], i, homes[1]) unless blocked(state, prev, i, homes[1])
        next
      end

      (8..14).each do |j|
        moves << Move.new(state[i], i, j) unless blocked(state, prev, i, j)
      end
    else
      # We are in the corridor, all we can do is go home
      homes = $home[state[i]]
      if state[homes[0]].nil?
        moves << Move.new(state[i], i, homes[0]) unless blocked(state, prev, i, homes[0])
      elsif state[homes[1]].nil?
        next unless state[i] == state[homes[0]]
        moves << Move.new(state[i], i, homes[1]) unless blocked(state, prev, i, homes[1])
      end
    end
  end
  moves
end

Move = Struct.new(:m, :from, :to) do
  def to_s
    "#{m}: #{from}->#{to}"
  end
end

class Queue
  attr_accessor :points, :dist

  def initialize(dist)
    self.points = Set[]
    self.dist = dist
  end

  def extract_min()
    p = points.min_by { |v|
      dist[v]
    }
    points.delete(p)
    p
  end

  def add(p)
    points.add(p)
  end
end
