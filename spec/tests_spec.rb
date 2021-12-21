require "matrix"

require_relative "../lib.rb"

RSpec.describe "code" do
  it "dirac dice" do
    dice = DiracDice.new(123)
    expect(dice.roll).to eq 3
    expect(dice.roll).to eq 2
    expect(dice.roll).to eq 1
    expect(dice.roll).to be_nil
  end

  it "dirac dice" do
    dice = DiracDice.new(1)
    expect(play_game(dice, [4, 8], 10)).to be_nil
  end

  it "dirac dice" do
    dice = DiracDice.new(11111111111111111111111)
    expect(play_game(dice, [1, 2], 10)).to eq 0
    expect(play_game(dice, [9, 2], 10)).to eq 1
  end
end
