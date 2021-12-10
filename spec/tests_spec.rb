require_relative "../lib.rb"

RSpec.describe Point do
  it "is equal " do
    expect(Point.new(1, 2, 9, 9) == Point.new(1, 2, 9, 9)).to be true
  end

  it "can be in a set" do
    set = Set[
      Point.new(1, 2, 9, 9),
      Point.new(2, 2, 9, 9),
      Point.new(4, 2, 9, 9),
    ]
    expect(set.size).to be 3
    expect(set.include?(Point.new(2, 2, 9, 9))).to be_truthy

    set << Point.new(2, 2, 9, 9)
    expect(set.size).to eq 3
  end

  it "adjacent" do
    expect(Point.new(0, 5, 5, 5).adjacent_points.size).to eq 2
    expect(Point.new(0, 0, 5, 5).adjacent_points.size).to eq 2
  end
end
