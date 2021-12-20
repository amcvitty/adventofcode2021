require_relative "lib.rb"

scanners = read_scanners
ordering = Array.new(scanners.size) { |i| i }
# Loop precondition:
# - everything before e has been explored for matches
# - everything before u has found a match (with lower index) and been transformed
# to coordinates relative to scanner[0]
e = 0
u = 1
while u < scanners.size
  (u..scanners.size - 1).each do |i|
    puts "Looking for overlap  (#{e}, #{i})"

    res = find_if_overlap(scanners[e], scanners[i])

    if res
      if e == 3 && i == 4
        puts scanners[e], scanners[i]
      end
      rot, disp = res
      scanners[i] = scanners[i].map { |p| rot * p - disp }
      puts "Got a hit: #{disp} - putting #{i} to #{u}"

      tmp = scanners[u]
      scanners[u] = scanners[i]
      scanners[i] = tmp

      tmp = ordering[u]
      ordering[u] = ordering[i]
      ordering[i] = tmp
      puts "Ordering: #{ordering.to_s}"
      u += 1
    end
  end
  e += 1
end

puts scanners.reduce(&:union).size
