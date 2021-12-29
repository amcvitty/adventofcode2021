require_relative "../lib.rb"
RSpec.describe "Code" do
  lines = ["inp w",
           "add z w",
           "mod z 2",
           "div w 2",
           "add y w",
           "mod y 2",
           "div w 2",
           "add x w",
           "mod x 2",
           "div w 2",
           "mod w 2"]

  it "reads line" do
    expect(read_line lines[0]).to eq Instruction.new(OP_INP, 0)
    expect(read_line lines[1]).to eq Instruction.new(OP_ADD, 3, 0, true)
    expect(read_line lines[2]).to eq Instruction.new(OP_MOD, 3, 2)
    expect(read_line lines[3]).to eq Instruction.new(OP_DIV, 0, 2)
  end

  it "operates" do
    alu = Alu.new([
      "inp x",
      "mul x -1",
    ])
    state = alu.operate("31")
    expect(state["x"]).to eq -3
  end

  it "operates2" do
    alu = Alu.new([
      "inp z",
      "inp x",
      "mul z 3",
      "eql z x",
    ])
    state = alu.operate("13")
    expect(state["z"]).to eq 1
    state = alu.operate("26")
    expect(state["z"]).to eq 1
    state = alu.operate("27")
    expect(state["z"]).to eq 0
  end

  it "Splits binary" do
    alu = Alu.new([
      "inp w",
      "add z w",
      "mod z 2",
      "div w 2",
      "add y w",
      "mod y 2",
      "div w 2",
      "add x w",
      "mod x 2",
      "div w 2",
      "mod w 2",
    ])
    state = alu.operate("3")

    expect(state).to eq ({ "w" => 0, "x" => 0, "y" => 1, "z" => 1 })
  end

  it "no_zeroes" do
    expect(no_zeroes(1204)).to be_falsey
    expect(no_zeroes(1234)).to be_truthy
  end

  it "decodes" do
    expect(decode_alphabet(27)).to eq "AA"
  end

  it "encodes" do
    expect(encode_alphabet("A")).to eq 1
    expect(encode_alphabet("AA")).to eq 27
    expect(decode_alphabet(encode_alphabet("ABCDEFG"))).to eq "ABCDEFG"
  end
end
