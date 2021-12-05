require_relative "../lib.rb"

RSpec.describe Line do
  it "has DIRECTION" do
    l = Line.new(1, 2, 1, 4)
    expect(l.direction).to be :vertical
    l = Line.new(3, 1, 2, 1)
    expect(l.direction).to be :horizontal
  end

  it "has a vector" do
    expect(parseline("0,9 -> 5,9").vector).to eq [1, 0, 5]
    expect(parseline("8,0 -> 0,8").vector).to eq [-1, 1, 8]
    expect(parseline("9,4 -> 3,4").vector).to eq [-1, 0, 6]
    expect(parseline("2,2 -> 2,1").vector).to eq [0, -1, 1]
  end

  it "parses strings  " do
    p = parseline "0,9 -> 5,9"
    expect(p.x1).to eq 0
    expect(p.y1).to eq 9
    expect(p.x2).to eq 5
    expect(p.y2).to eq 9
  end
end

RSpec.describe Board do
  it "marks points " do
    b = Board.new(3, 3)
    b.mark_point(2, 1)
    b.mark_point(2, 1)
    expect(b.get_point(2, 1)).to eq 2
  end
  it "marks lines" do
    b = Board.new(3, 3)
    b.draw(Line.new(0, 0, 0, 2))
    expect(b.get_point(0, 0)).to eq 1
    expect(b.get_point(0, 1)).to eq 1
    expect(b.get_point(0, 2)).to eq 1
    expect(b.get_point(1, 2)).to eq 0
  end
  it "marks lines the other direction" do
    b = Board.new(3, 3)
    b.draw(Line.new(0, 2, 0, 0))
    expect(b.get_point(0, 0)).to eq 1
    expect(b.get_point(0, 1)).to eq 1
    expect(b.get_point(0, 2)).to eq 1
    expect(b.get_point(1, 2)).to eq 0
  end
end
