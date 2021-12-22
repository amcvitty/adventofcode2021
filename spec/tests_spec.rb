require "matrix"

require_relative "../lib.rb"

RSpec.describe "code" do
  it "inserts to empty list" do
    n = Node.new(1..5, "on")
    expect(insert(n, nil)).to eq cons(Node.new(1..5, "on"), nil)
  end

  it "equals" do
    l1 = cons(1, cons(2, cons(3, nil)))
    l2 = cons(1, cons(2, cons(3, nil)))
    expect(l1).to eq l2
  end

  it "size" do
    l1 = cons(1, cons(2, cons(3, nil)))
    expect(l1.size).to eq 3
  end

  it "cons with add" do
    Node.new(1..5, "on") + Node.new(6..10, "off") + nil
  end
end
