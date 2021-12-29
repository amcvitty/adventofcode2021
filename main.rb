require_relative "lib.rb"

lines = $stdin.read.split "\n"
state = lines.map { |l| l.chars }

def dump(state)
  state.each do |l|
    puts l.join("")
  end
  puts
end

def move_east(state, new_state, r, c)
  rows = state.size
  cols = state[0].size
  if state[r][c] == ">"
    c2 = (c + 1) % cols
    if state[r][c2] == "."
      new_state[r][c2] = ">"
    else
      new_state[r][c] = ">"
    end
  elsif state[r][c] == "v"
    new_state[r][c] = "v"
  end
end

def move_south(state, new_state, r, c)
  rows = state.size
  cols = state[0].size
  if state[r][c] == "v"
    r2 = (r + 1) % rows
    if state[r2][c] == "."
      new_state[r2][c] = "v"
    else
      new_state[r][c] = "v"
    end
  elsif state[r][c] == ">"
    new_state[r][c] = ">"
  end
end

puts "Initial state: "
dump state
i = 0
while true
  i += 1
  new_state = Array.new(state.size) { Array.new(state[0].size, ".") }
  state.size.times do |r|
    state[0].size.times do |c|
      move_east(state, new_state, r, c)
    end
  end
  new_state2 = Array.new(state.size) { Array.new(state[0].size, ".") }

  new_state.size.times do |r|
    new_state[0].size.times do |c|
      move_south(new_state, new_state2, r, c)
    end
  end
  puts "After #{i} steps: "
  # dump new_state2
  if state == new_state2
    puts "No movement: #{i}"
    break
  end
  state = new_state2
end
