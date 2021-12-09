require_relative "../lib.rb"

RSpec.describe "code" do
  it "marks points " do
    expect(sort_string("acb")).to eq "abc"
  end

  it "permutes" do
    expect(permute_string("a")).to eq ["a"]
    expect(permute_string("as")).to eq ["as", "sa"]
    expect(permute_string("abc")).to eq ["abc", "acb", "bac", "bca", "cab", "cba"]
  end

  it "translates " do
    expect(translate("bac", "cab")).to eq "cba"
  end

  it "solves" do
    digits = "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb".split(" ")
    expect(permutation_solves("dgbcaef", digits)).to be_truthy
  end
  it "decodes whole line" do
    expect(decode_line "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe").to eq 8394
  end
end
