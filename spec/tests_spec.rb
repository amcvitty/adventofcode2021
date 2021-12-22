require "matrix"

require_relative "../lib.rb"

RSpec.describe "code" do
  it "limits" do
    expect(limit(-100, -75)).to eq 1..0
    expect(limit(100, 175)).to eq 1..0
    expect(limit(-100, 25)).to eq -50..25
    expect(limit(-50, -50)).to eq -50..-50
    expect(limit(50, 50)).to eq 50..50
  end
end
