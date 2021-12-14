require_relative "../lib.rb"

RSpec.describe "code" do
  it "lists" do
    expect(apply("NNCB", [Rule.new("NN", "C")])).to eq "NCNCB"
  end

  it "hashcounts" do
    hc = to_hashcount("NNNCB")
    expect(hc).to eq ({
         "NN" => 2,
         "NC" => 1,
         "CB" => 1,
       })
  end
end
