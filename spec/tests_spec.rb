require_relative "../lib.rb"

RSpec.describe "code" do
  it "to_s" do
    expect(Leaf.new(1).to_s).to eq "1"
    expect(Node.new(Leaf.new(1), Leaf.new(2)).to_s).to eq "[1,2]"
  end

  it "sets parents" do
    l = Leaf.new(1)
    r = Leaf.new(1)
    n = Node.new(l, r)
    expect(l.parent).to eq n
    expect(r.parent).to eq n
  end

  it "parses" do
    node = PairParser.new("[1,2]").parse
    expect(node.l.val).to eq 1
    expect(node.r.val).to eq 2
  end

  it "parses & back to same string" do
    str = "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]"
    expect(PairParser.new(str).parse.to_s).to eq str
  end
  it "parses & back to same string with big_numbers" do
    str = "[[[[0,7],4],[15,[0,13]]],[1,1]]"
    expect(PairParser.new(str).parse.to_s).to eq str
  end

  it "compares" do
    expect(Leaf.new(1) == Leaf.new(1)).to be_falsey
  end

  it "finds closest left" do
    pair = PairParser.new("[[[[[9,8],1],2],3],4]").parse
    leaf = pair.l.l.l.l.l
    expect(leaf.val).to eq 9
    expect(closest_left(leaf)).to be_nil

    pair = PairParser.new("[7,[6,[5,[4,[3,2]]]]]").parse
    leaf = pair.r.r.r.r.l
    expect(leaf.val).to eq 3
    expect(closest_left(leaf).val).to eq 4
  end

  # it "explodes" do
  #   pair = PairParser.new("[[[[[9,8],1],2],3],4]").parse
  #   explode(pair.l.l.l.l)
  #   expect(pair.to_s).to eq "[[[[0,9],2],3],4]"
  # end

  # it "find_to_explode" do
  #   pair = PairParser.new("[[[[[9,8],1],2],3],4]").parse
  #   expect(find_to_explode(pair, 0).to_s).to eq "[9,8]"
  # end

  it "explodes" do
    pair = PairParser.new("[[[[[9,8],1],2],3],4]").parse
    explode(pair)
    expect(pair.to_s).to eq "[[[[0,9],2],3],4]"

    pair = PairParser.new("[7,[6,[5,[4,[3,2]]]]]").parse
    explode(pair)
    expect(pair.to_s).to eq "[7,[6,[5,[7,0]]]]"

    pair = PairParser.new("[[6,[5,[4,[3,2]]]],1]").parse
    explode(pair)
    expect(pair.to_s).to eq "[[6,[5,[7,0]]],3]"

    pair = PairParser.new("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]").parse
    explode(pair)
    expect(pair.to_s).to eq "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"

    pair = PairParser.new("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]").parse
    explode(pair)
    expect(pair.to_s).to eq "[[3,[2,[8,0]]],[9,[5,[7,0]]]]"
  end

  it "splits" do
    pair = PairParser.new("[[[[0,7],4],[15,[0,13]]],[1,1]]").parse
    split_pair(pair)
    expect(pair.to_s).to eq "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]"
    split_pair(pair)
    expect(pair.to_s).to eq "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]"
  end

  it "Mag" do
    pair = PairParser.new("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]").parse
    expect(magnitude(pair)).to eq 3488
  end
end
