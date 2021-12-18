# state  [x, y, vx, vy]
def step(state)
  x, y, vx, vy = state
  x += vx
  y += vy
  vx -= vx / vx.abs if vx != 0
  vy -= 1
  return [x, y, vx, vy]
end

# state [x, y, vx, vy]
# target [x1,x2, y1,y2]
def in_target(state, target)
  x, y = state
  x1, x2, y1, y2 = target
  return x >= x1 && x <= x2 && y >= y1 && y <= y2
end

# below the target and falling
def dead(state, target)
  x, y, vx, vy = state
  x1, x2, y1, y2 = target

  return y < y1 && vy < 0 ||
           x < x1 && vx < 0 ||
           x > x2 && vx > 0
end

def run(vx, vy, target)
  state = [0, 0, vx, vy]
  steps = [state]
  until dead(state, target) || in_target(state, target)
    state = step(state)
    steps << state
  end
  return steps
end

def max_y(steps)
  steps.max_by { |state| state[1] }[1]
end

def draw_map(steps, target)
  x1, x2, y1, y2 = target

  min_x, max_x = steps.map { |state| state[0] }.minmax
  min_y, max_y = steps.map { |state| state[1] }.minmax
  min_x = [min_x, x1].min
  max_x = [max_x, x2].max
  min_y = [min_y, y1].min
  max_y = [max_y, y2].max

  print "    "
  (min_x..max_x).each { |x| print x % 10 }
  puts
  (0..(max_y - min_y)).each do |y|
    y = max_y - y
    printf "%3d:", y
    (min_x..max_x).each do |x|
      if steps.map { |s| s[0, 2] }.include? [x, y]
        print "#"
      elsif x >= x1 && x <= x2 && y >= y1 && y <= y2
        print "T"
      else
        print "."
      end
    end
    puts
  end
end
