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
    q = Queue.new(2, 2, dist)

    expect(q.extract_min()).to eq Point.new(0, 0)

    # If we change the distances, the queue will see the changes
    dist[1][1] = 0
    expect(q.extract_min()).to eq Point.new(1, 1)

    expect(q.extract_min()).to eq Point.new(1, 0)
    expect(q.extract_min()).to eq Point.new(0, 1)
    expect(q.extract_min).to be_nil
  end
end
