require "matrix"
require "matrix"

require_relative "../lib.rb"

RSpec.describe "code" do
  it "queues" do
    pq = PQueue.new([2, 3, 1]) { |a, b| a > b }

    expect(pq.pop).to eq 3
    expect(pq.pop).to eq 2
    expect(pq.pop).to eq 1
  end

  it "adjusts when something changes" do
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
    expect(q.pop.tag).to eq "b"
    expect(q.pop.tag).to eq "a"
    expect(q.pop).to be_nil
  end
end
