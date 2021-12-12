require_relative "../lib.rb"

RSpec.describe "code" do
  it "lists" do
    x = List.new("A", nil).cons("B")
    tl = x.cons("C")
    expect(tl.length).to eq 3
    expect(x.length).to eq 2

    expect(tl.include?("C")).to be_truthy
    expect(x.include?("C")).to be false
    expect(tl.include?("X")).to be false

    expect(tl.to_a).to eq ["A", "B", "C"]
  end
end
