require_relative "../lib.rb"

RSpec.describe "code" do
  it "is equal " do
    expect(score("])}>".reverse.chars)).to eq 294
  end
end
