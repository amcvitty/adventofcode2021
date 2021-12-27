require "matrix"

require_relative "../lib.rb"

RSpec.describe PQVal do
  it "uses the hash" do
    x = {}

    x[PQVal.new("a", 1)] = 1
    x[PQVal.new("a", 2)] = 2
    expect(x.size).to eq 1
  end
end
RSpec.describe PQueue do
  it "extract_min" do
    pq = PQueue.new([
      PQVal.new(2, 2),
      PQVal.new(3, 3),
      PQVal.new(1, 1),
    ])

    expect(pq.extract_min.val).to eq 1
    expect(pq.extract_min.val).to eq 2
    expect(pq.extract_min.val).to eq 3
  end

  it "inserts (and sorts!)" do
    pq = PQueue.new([
      PQVal.new(2, -2),
      PQVal.new(5, -5),
      PQVal.new(1, -1),
    ])

    pq.insert(PQVal.new(8, -8))
    pq.insert(PQVal.new(7, -7))
    pq.insert(PQVal.new(3, -3))

    expect(pq.extract_min.val).to eq 8
    expect(pq.extract_min.val).to eq 7
    expect(pq.extract_min.val).to eq 5
    expect(pq.extract_min.val).to eq 3
    expect(pq.extract_min.val).to eq 2
    expect(pq.extract_min.val).to eq 1
    expect(pq.extract_min).to eq nil
  end

  it "adjusts when something changes" do
    q = PQueue.new()
    q << (a = PQVal.new("a", 10))
    q << (b = PQVal.new("b", 8))
    q << PQVal.new("c", 3)
    expect(q.size).to eq 3
    expect(q.pop.val).to eq "c"
    expect(q.size).to eq 2

    a.priority = 1
    q << a
    expect(q.size).to eq 2
    expect(q.pop.val).to eq "a"
    expect(q.size).to eq 1
    expect(q.pop.val).to eq "b"
    expect(q.size).to eq 0

    expect(q.pop).to be_nil
  end

  it "throws on increasing priority" do
    begin
      q = PQueue.new()
      q << (b = PQVal.new("b", 8))
      expect { q << (b = PQVal.new("b", 10)) }.to raise_error(UncaughtThrowError)
    rescue
    end
  end
end
