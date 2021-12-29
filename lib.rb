DEBUG = true

Instruction = Struct.new(:op, :dest, :x, :indirect)

OP_CODES = ["inp",
            "add",
            "mul",
            "div",
            "mod",
            "eql"]
REGS = "wxyz".chars

OP_INP = 0
OP_ADD = 1
OP_MUL = 2
OP_DIV = 3
OP_MOD = 4
OP_EQL = 5

def read_line(line)
  op, dest, x = line.split " "
  if /-?\d+/.match(x)
    x = x.to_i
  elsif x.nil?
  else
    x = REGS.find_index x
    indirect = true
  end
  dest = REGS.find_index dest
  op = OP_CODES.find_index(op)
  Instruction.new(op, dest, x, indirect)
end

class Alu
  attr_accessor :inx

  def initialize(lines)
    @inx = lines.map { |line| read_line(line) }
    @inp_ix = []
    @inx.each_with_index do |inx, ix|
      if inx.op == OP_INP
        @inp_ix << ix
      end
    end
  end

  def do_operate(input, from, to, registers = [0, 0, 0, 0])
    input = input.to_s.chars.map(&:to_i)
    @inx[from, to - from].each do |inx|
      x = inx.indirect ? registers[inx.x] : inx.x
      registers[inx.dest] = case inx.op
        when OP_INP
          input.shift
        when OP_ADD
          registers[inx.dest] + x
        when OP_MUL
          registers[inx.dest] * x
        when OP_DIV
          if x == 0
            throw "Error in #{inx}: #{x} == 0"
          end
          registers[inx.dest] / x
        when OP_MOD
          if registers[inx.dest] < 0
            throw "Error in #{inx}: #{registers[inx.dest]} < 0"
          end
          registers[inx.dest] % x
        when OP_EQL
          registers[inx.dest] == x ? 1 : 0
        else
          throw "Unrecognised op #{@inx} "
        end
    end
    registers
  end

  def do_digit(input, start, digits, registers = [0, 0, 0, 0])
    do_operate(input, @inp_ix[start],
               (start + digits >= @inp_ix.size) ? @inx.size : @inp_ix[start + digits],
               registers)
  end

  def operate(input)
    registers = do_operate(input, 0, @inx.size)
    {
      "w" => registers[0],
      "x" => registers[1],
      "y" => registers[2],
      "z" => registers[3],
    }
  end

  def test_z_digit(input, digits)
  end

  def test_z(input)
    registers = do_operate(input)
    registers[3] == 0
  end
end

def no_zeroes(n)
  n.to_s.chars.none? { |x| x == "0" }
end

def decode_alphabet(n)
  str = ""
  while n > 0
    str << ("A".."Z").to_a[n % 26 - 1]
    n /= 26
  end
  str.reverse
end

def encode_alphabet(str)
  n = 0
  str.chars.each do |c|
    n = n * 26 + ("A".."Z").to_a.find_index(c) + 1
  end
  n
end
