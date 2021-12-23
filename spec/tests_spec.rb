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

  it "inserts" do
    list = nil
    list = cons(Node.new(12..12, "on"), list)
    list = cons(Node.new(8..10, "off"), list)
    list = cons(Node.new(6..7, "on"), list)
    list = cons(Node.new(4..5, "on"), list)
    list = cons(Node.new(2..3, "off"), list)
    list = cons(Node.new(1..1, "on"), list)

    list2 = list

    list = nil
    list = insert(Node.new(1..10, "on"), list)
    list = insert(Node.new(2..5, "off"), list)
    list = insert(Node.new(8..10, "off"), list)
    list = insert(Node.new(4..7, "on"), list)
    list = insert(Node.new(12..12, "on"), list)

    expect(list.to_s).to eq list2.to_s
  end
end
