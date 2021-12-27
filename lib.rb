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
    [1, 2],
    [2, 3],

    [4, 5],
    [5, 6],
    [6, 7],

    [8, 9],
    [9, 10],
    [10, 11],

    [12, 13],
    [13, 14],
    [14, 15],

    [16, 17],
    [21, 22],

  ]

  # These pass through the nodes where we can't stop
  # at the top of each cave, so count for 2
  doubles = [
    [3, 17],
    [3, 18],
    [17, 18],

    [7, 18],
    [7, 19],
    [18, 19],

    [11, 19],
    [11, 20],
    [19, 20],

    [15, 20],
    [15, 21],
    [20, 21],
  ]
  nodes = 22
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

  pos = Array.new(23, nil)
  c = 3
  lines.each do |line|
    m = /([A-D]).*([A-D]).*([A-D]).*([A-D]).*/.match(line)
    next unless m
    pos[0 + c], pos[4 + c], pos[8 + c], pos[12 + c] = m.captures
    c -= 1
  end
  return pos
end

def dump(state)
  puts "#############"
  puts "##{state[16] || "."}#{state[17] || "."}.#{state[18] || "."}.#{state[19] || "."}.#{state[20] || "."}.#{state[21] || "."}#{state[22] || "."}#"
  puts "####{state[3] || "."}##{state[7] || "."}##{state[11] || "."}##{state[15] || "."}###"
  puts "  ##{state[2] || "."}##{state[6] || "."}##{state[10] || "."}##{state[14] || "."}#"
  puts "  ##{state[1] || "."}##{state[5] || "."}##{state[9] || "."}##{state[13] || "."}#"
  puts "  ##{state[0] || "."}##{state[4] || "."}##{state[8] || "."}##{state[12] || "."}#"
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

$target = [
  "A", "A",
  "A", "A",
  "B", "B",
  "B", "B",
  "C", "C",
  "C", "C",
  "D", "D",
  "D", "D",
  nil, nil, nil, nil, nil, nil, nil,
]

$home = {
  "A" => [0, 1, 2, 3],
  "B" => [4, 5, 6, 7],
  "C" => [8, 9, 10, 11],
  "D" => [12, 13, 14, 15],
}

# TODO - valid moves still assuming there are 15 spots
def valid_moves(state, prev)
  moves = []
  23.times do |i|
    next unless state[i]
    homes = $home[state[i]]

    if $target[i] == state[i]
      # We're in the right cave
      # No moves possible/necessary if everything below is  good
      if homes.filter { |h| h < i }.all? { |h|
        $target[i - 1] == state[i - 1]
      }
        next
      end
    end
    if i < 16
      # in a cave
      if i % 4 != 3
        # trapped by one above (wee optimisation)
        next unless state[i + 1].nil?
      end

      # If we can go home in one move, do. TODO - this is the same as the one below, and will
      # get too long to repeat! maybe get_home_move(state, prev, i)
      home_move = get_home_move(state, prev, i)
      if !home_move.nil?
        moves << home_move
        next
      end

      (8..14).each do |j|
        moves << Move.new(state[i], i, j) unless blocked(state, prev, i, j)
      end
    else
      # We are in the corridor, all we can do is go home
      home_move = get_home_move(state, prev, i)
      if !home_move.nil?
        moves << home_move
        next
      end
    end
  end
  moves
end

def get_home_move(state, prev, i)
  homes = $home[state[i]]

  homes.each do |j|
    if state[j].nil? && homes.filter { |h| h < j }.all? { |h|
      $target[i - 1] == state[i - 1]
    }
      return Move.new(state[i], i, j) unless blocked(state, prev, i, j)
    end
  end
  nil
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

# Implementation broadly from Introduction to Algorithms (Cormen, Leiserson, Rivest 1985),
# ch 7 building a  heap
class PQueue
  attr_accessor :a

  def initialize(content = [], &cmp)
    @a = content.dup
    @cmp = cmp || proc { |a, b| a <=> b }
    build_heap
  end

  def extract_max
    if a.size == 0
      return nil
    end

    max = a[0]
    a[0] = a.pop
    heapify(0)
    return max
  end

  def insert(x)
    i = a.size
    while i > 0 && a[parent(i)] < x
      a[i] = a[parent(i)]
      i = parent(i)
    end
    a[i] = x
  end

  # Leaving as public for testing right now
  # private

  def heapify(i)
    l = left(i)
    r = right(i)
    largest = i
    largest = l if l < a.size && a[l] > a[largest]
    largest = r if r < a.size && a[r] > a[largest]
    if largest != i
      tmp = a[i]
      a[i] = a[largest]
      a[largest] = tmp
      heapify(largest)
    end
  end

  def build_heap
    # Bottom half (i > a.size/2) is already single-item heaps
    i = a.size >> 1
    while i >= 0
      heapify(i)
      i -= 1
    end
  end

  def parent(i)
    i - 1 >> 1
  end

  def left(i)
    (i + 1 << 1) - 1
  end

  def right(i)
    i + 1 << 1
  end
end
