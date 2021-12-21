require "matrix"

require_relative "../lib.rb"

RSpec.describe "code" do
  it "adds" do
    expect(add([1, 2], [5, 6])).to eq [6, 8]
  end
  it "multiplys" do
    expect(multiply([1, 2], 4)).to eq [4, 8]
  end
end
