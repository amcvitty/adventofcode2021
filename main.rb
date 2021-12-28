require_relative "lib.rb"

lines = $stdin.read.split "\n"

alu = Alu.new(lines)

## For 4,5 & 8,9
##  1 8 1 5
##  2 9 1 5
# For Pair: 6, 7
# 6 1: : 0
# 7 2: : 0
# 8 3: : 0
# 9 4: : 0
# For Pair: 5, 8
# For Pair: 4, 9
# For Pair: 3, 10
# 9 1: : 0
# For Pair: 2, 11
# 1 1: : 0
# 2 2: : 0
# 3 3: : 0
# 4 4: : 0
# 5 5: : 0
# 6 6: : 0
# 7 7: : 0
# 8 8: : 0
# 9 9: : 0
# For Pair: 1, 12
# 1 6: : 0
# 2 7: : 0
# 3 8: : 0
# 4 9: : 0
# For Pair: 0, 13

(1..9).each do |d0| # ???
  (4..4).each do |d1|
    (1..9).each do |d2|
      # (9..9).each do |d3|
      d3 = 9
      (1..2).each do |d4|
        # (1..9).each do |d5|
        d5 = d4 + 7
        (6..9).each do |d6|
          # (1..4).each do |d7|
          d7 = d6 - 5
          (1..1).each do |d8|
            (5..5).each do |d9|
              # (1..1).each do |d10|
              # (9..9).each do |d11|
              # (9..9).each do |d12|

              d10 = 1
              d11 = d2
              d12 = d1 + 5
              (1..9).each do |d13| # ???
                registers = [0, 0, 0, 0]
                registers = alu.do_digit(d0, 0, 1, registers)
                registers = alu.do_digit(d1, 1, 1, registers)
                registers = alu.do_digit(d2, 2, 1, registers)
                registers = alu.do_digit(d3, 3, 1, registers)
                registers = alu.do_digit(d4, 4, 1, registers)
                registers = alu.do_digit(d5, 5, 1, registers)
                registers = alu.do_digit(d6, 6, 1, registers)
                registers = alu.do_digit(d7, 7, 1, registers)
                registers = alu.do_digit(d8, 8, 1, registers)
                registers = alu.do_digit(d9, 9, 1, registers)
                registers = alu.do_digit(d10, 10, 1, registers)
                registers = alu.do_digit(d11, 11, 1, registers)
                registers = alu.do_digit(d12, 12, 1, registers)
                registers = alu.do_digit(d13, 13, 1, registers)

                puts "#{d0} #{d13} #{registers[3]} " if registers[3] == 0
              end
            end
          end
          # end
          #       end
          #     end
          #   end
          # end
          # end
        end
      end
    end
  end
end
exit
# (1..9).each do |d6|
#   (1..9).each do |d7|
#     registers = alu.do_digit(d6 * 10 + d7, 6, 2) #, [0, 0, 0, encode_alphabet("BHFDKC")])
#     puts "#{d6} #{d7}: #{decode_alphabet(registers[3])}: #{registers[3]}"
#   end
# end
def find_pair(alu, pos1)
  pos2 = 13 - pos1
  puts "For Pair: #{pos1}, #{pos2}"
  (1..9).each do |d1|
    (1..9).each do |d2|
      registers = alu.do_digit(d1, pos1, 1) #, [0, 0, 0, encode_alphabet("BHFDKC")])
      registers = alu.do_digit(d2, pos2, 1, registers)

      puts "#{d1} #{d2}: #{decode_alphabet(registers[3])}: #{registers[3]}" if registers[3] == 0
    end
  end
end

find_pair(alu, 6)
find_pair(alu, 5)
find_pair(alu, 4)
find_pair(alu, 3)
find_pair(alu, 2)
find_pair(alu, 1)
find_pair(alu, 0)

puts "For Pair: 5,8"
(1..9).each do |d4|
  (1..9).each do |d5|
    (1..9).each do |d8|
      (1..9).each do |d9|
        input = d4 * 100000 + d5 * 10000 + 7200 + d8 * 10 + d9
        registers = alu.do_digit(input, 4, 6) #, [0, 0, 0, encode_alphabet("BHFDKC")])

        puts "#{d1} #{d2}: #{decode_alphabet(registers[3])}: #{registers[3]}" if registers[3] == 0
      end
    end
  end
end
