require_relative "../lib.rb"

RSpec.describe "code" do
  let(:lines) {
    x = <<END
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
END
    x.split("\n")
  }

  it "hashcounts" do
    hc = to_hashcount("NNNCB")
    expect(hc).to eq ({
                       "NN" => 2,
                       "NC" => 1,
                       "CB" => 1,
                     })
  end

  it "lists" do
    expect(apply1("NNCB", [
      Rule.new("NN", "C"),
    ])).to eq "NCNCB"
  end

  it "asdf" do
    template = lines.shift
    lines.shift
    rules = {}
    lines.each { |l|
      pair, ins = /(\w\w) -> (\w)/.match(l).captures
      rules[pair] = ins
    }

    expect(apply(to_hashcount(template), rules)).to eq to_hashcount("NCNBCHB")
    expect(applyn(to_hashcount(template), rules, 2)).to eq to_hashcount("NBCCNBBBCBHCB")
    expect(applyn(to_hashcount(template), rules, 3)).to eq to_hashcount("NBBBCNCCNBBNBNBBCHBHHBCHB")
    expect(applyn(to_hashcount(template), rules, 4)).to eq to_hashcount("NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB")
  end
end
