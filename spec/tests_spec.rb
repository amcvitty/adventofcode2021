require "matrix"

require_relative "../lib.rb"

class MyVal
  attr_accessor :val, :priority

  def initialize(val, priority)
    @val = val
    @priority = priority
  end

  def inspect
    to_s
  end

  def to_s
    "#{val}(#{priority})"
  end

  def hash
    val.hash
  end

  def eql?(other)
    !other.nil? && val.eql?(other.val)
  end
end

RSpec.describe MyVal do
  it "uses the hash" do
    x = {}

    x[MyVal.new("a", 1)] = 1
    x[MyVal.new("a", 2)] = 2
    expect(x.size).to eq 1
  end
end
RSpec.describe PQueue do
  it "extract_min" do
    pq = PQueue.new([
      MyVal.new(2, 2),
      MyVal.new(3, 3),
      MyVal.new(1, 1),
    ])

    expect(pq.extract_min.val).to eq 1
    expect(pq.extract_min.val).to eq 2
    expect(pq.extract_min.val).to eq 3
  end

  it "inserts (and sorts!)" do
    pq = PQueue.new([
      MyVal.new(2, -2),
      MyVal.new(5, -5),
      MyVal.new(1, -1),
    ])

    pq.insert(MyVal.new(8, -8))
    pq.insert(MyVal.new(7, -7))
    pq.insert(MyVal.new(3, -3))

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
    q << (a = MyVal.new("a", 10))
    q << (b = MyVal.new("b", 8))
    q << MyVal.new("c", 3)
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
      q << (b = MyVal.new("b", 8))
      expect { q << (b = MyVal.new("b", 10)) }.to raise_error(UncaughtThrowError)
    rescue
    end
  end
end
