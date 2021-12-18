require_relative "lib.rb"

# target = [20, 30, -10, -5]
target = [230, 283, -107, -57]
x1, x2, y1, y2 = target

# Need some bounds for the search space.
#
# Key insight here for vy_max/min - we will hit the same y values on the way up
# as on the way down, so if we go more than the target on the first step, we
# will certainly miss it on the way down too
#
# For vx_max, again, we know if we overshoot on the first step we'll miss it
vy_max = [y1.abs, y2.abs].max
# To get all solutions, we need to go below zero here
vy_min = -vy_max
# We don't need to go below 0 for x, because the target is on the right!
vx_max = x2

max_max_y = 0
solutions = 0
(vy_min..vy_max).each do |vy|
  (0..vx_max).each do |vx|
    steps = run(vx, vy, target)
    if in_target(steps.last, target)
      solutions += 1
      x, y = steps.last
      max_y = max_y(steps)
      max_max_y = [max_max_y, max_y].max
      puts "#{vx},#{vy}: #{x},#{y} in target. Max y: #{max_y(steps)}"
    end
  end
end
puts "Solutions: #{solutions}"
puts "Max max y: #{max_max_y}"

# steps = run(23, -10, target)
# draw_map(steps, target)
