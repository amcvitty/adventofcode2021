require "matrix"

require_relative "../lib.rb"

RSpec.describe "code" do
  it "manha" do
    expect(manhattan_distance(
      Matrix.column_vector([1105, -1205, 1229]),
      Matrix.column_vector([-92, -2380, -20])
    )).to eq 3621
  end
end
