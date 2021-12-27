require "matrix"

require_relative "../lib.rb"

RSpec.describe PQueue do
  it "parent" do
    q = PQueue.new
    expect(q.parent(1)).to eq 0
    expect(q.parent(2)).to eq 0
    expect(q.parent(3)).to eq 1
    expect(q.parent(4)).to eq 1
    expect(q.parent(5)).to eq 2
    expect(q.parent(6)).to eq 2
  end
  it "left" do
    q = PQueue.new
    expect(q.left(0)).to eq 1
    expect(q.left(1)).to eq 3
    expect(q.left(2)).to eq 5
    expect(q.left(3)).to eq 7
    expect(q.left(4)).to eq 9
    expect(q.left(5)).to eq 11
    expect(q.left(6)).to eq 13
  end
  it "right" do
    q = PQueue.new
    expect(q.right(0)).to eq 2
    expect(q.right(1)).to eq 4
    expect(q.right(2)).to eq 6
    expect(q.right(3)).to eq 8
    expect(q.right(4)).to eq 10
    expect(q.right(5)).to eq 12
    expect(q.right(6)).to eq 14
  end

  it "heapifies" do
    q = PQueue.new([16, 4, 10, 14, 7, 9, 3, 2, 8, 1])
    expect(q.a.size).to eq 10

    q.heapify(1)

    expect(q.a).to eq [16, 14, 10, 8, 7, 9, 3, 2, 4, 1]
  end

  it "extract_max" do
    pq = PQueue.new([2, 3, 1])

    expect(pq.extract_max).to eq 3
    expect(pq.extract_max).to eq 2
    expect(pq.extract_max).to eq 1
  end
  it "inserts (and sorts!)" do
    pq = PQueue.new([2, 8, 1])

    pq.insert(5)
    pq.insert(7)
    pq.insert(3)
    expect(pq.extract_max).to eq 8
    expect(pq.extract_max).to eq 7
    expect(pq.extract_max).to eq 5
    expect(pq.extract_max).to eq 3
    expect(pq.extract_max).to eq 2
    expect(pq.extract_max).to eq 1
  end

  xit "adjusts when something changes" do
    Dist = Struct.new(:d, :tag)
    q = PQueue.new() { |a, b|
      a.d < b.d
    }
    q << (a = Dist.new(10, "a"))
    q << (b = Dist.new(8, "b"))
    q << Dist.new(3, "c")
    expect(q.pop.tag).to eq "c"

    a.d = 1
    q << a
    expect(q.pop.tag).to eq "a"
    expect(q.pop.tag).to eq "b"
    expect(q.pop).to be_nil
  end
end
