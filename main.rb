require_relative "lib.rb"

lines = $stdin.read.split "\n"

alu = Alu.new(lines)

# Manual inspection of the code suggests that there are 14 sets of 18 lines of
# instructions, each of which will either push a letter on the stack or pop one
# off if given the right combination of "head of stack" and "input digit". By
# looking at the order of these, we see the pairs we need.
$final_digits = Array.new(14, nil)

def find_pair(alu, pos1, pos2)
  puts "For Pair: #{pos1}, #{pos2}"
  (1..9).each do |d1|
    (1..9).each do |d2|
      registers = alu.do_digit(d1, pos1, 1)
      registers = alu.do_digit(d2, pos2, 1, registers)

      # For part 1 we overwrite here and the max will be the last one left
      if registers[3] == 0
        puts "#{d1} #{d2}: #{decode_alphabet(registers[3])}: #{registers[3]}"
        $final_digits[pos1] = d1
        $final_digits[pos2] = d2
        return
      end
    end
  end
end

find_pair(alu, 0, 13)
find_pair(alu, 1, 12)
find_pair(alu, 2, 11)
find_pair(alu, 3, 8)
find_pair(alu, 4, 5)
find_pair(alu, 9, 10)
find_pair(alu, 6, 7)

puts "Uppers"
alu.inx.size.times do |i|
  inx = alu.inx[i]
  if [4].include?(i % 18) && inx.x == 1
    print(i / 18, ": ", " ", alu.inx[i + 11].x, "\n")
  end
end

puts "Downers"
alu.inx.size.times do |i|
  inx = alu.inx[i]
  if [4].include?(i % 18) && inx.x == 26
    print(i / 18, ": ", alu.inx[i + 1].x, " ", alu.inx[i + 11].x, "\n")
  end
end
puts $final_digits.map(&:to_s).join("").to_i
