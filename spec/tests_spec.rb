require_relative "../lib.rb"

RSpec.describe "code" do
  it "marks points " do
    expect(fuel_for(1)).to eq 1
    expect(fuel_for(2)).to eq 1 + 2
    expect(fuel_for(3)).to eq 1 + 2 + 3
    expect(fuel_for(4)).to eq 1 + 2 + 3 + 4
  end
end
