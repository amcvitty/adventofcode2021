require_relative "../lib.rb"

RSpec.describe "code" do
  it "adjacent " do
    expect(adj(1, 1, 3, 3).size).to eq 4
    expect(adj(0, 0, 3, 3).size).to eq 2
    expect(adj(3, 3, 3, 3).size).to eq 2
    expect(adj(3, 2, 3, 3).size).to eq 3
  end

  it "Queue extracts mins and is mutable" do
    dist = [[1, 5], [3, 4]]
    q = Queue.new(
      [
        Point.new(0, 0),
        Point.new(0, 1),
        Point.new(1, 0),
        Point.new(1, 1),
      ], dist
    )

    expect(q.extract_min()).to eq Point.new(0, 0)

    # If we change the distances, the queue will see the changes
    dist[1][1] = 0
    expect(q.extract_min()).to eq Point.new(1, 1)

    expect(q.extract_min()).to eq Point.new(1, 0)
    expect(q.extract_min()).to eq Point.new(0, 1)
    expect(q.extract_min).to be_nil
  end

  it "Explodes graphs" do
    puts explode_graph([[1, 1], [1, 1]], 2).map(&:to_s)
  end

  it "wraps" do
    expect(wrap(1)).to eq 1
    expect(wrap(8)).to eq 8
    expect(wrap(9)).to eq 9
    expect(wrap(10)).to eq 1
  end
end
