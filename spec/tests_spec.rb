require_relative "../lib.rb"

RSpec.describe "code" do
  it "adjacent " do
    expect(adjacent_points(1, 1, 3, 3).size).to eq 8
    expect(adjacent_points(0, 0, 3, 3).size).to eq 3
    expect(adjacent_points(3, 3, 3, 3).size).to eq 3
    expect(adjacent_points(3, 2, 3, 3).size).to eq 5
  end
end
