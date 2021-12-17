require_relative "../lib.rb"

RSpec.describe "code" do
  it "parses hex " do
    expect(PacketParser.new("D2FE28").parse).to eq [6, 4, 2021]
  end
  it "parses with subpackets 0" do
    expect(PacketParser.new("38006F45291200").parse).to eq [1, 6, [[6, 4, 10], [2, 4, 20]]]
  end
  it "parses with subpackets 1" do
    expect(PacketParser.new("EE00D40C823060").parse).to eq [7, 3, [[2, 4, 1], [4, 4, 2], [1, 4, 3]]]
  end

  it "calculates version_sums" do
    expect(vsum PacketParser.new("8A004A801A8002F478").parse).to eq 16
    expect(vsum PacketParser.new("620080001611562C8802118E34").parse).to eq 12
    expect(vsum PacketParser.new("C0015000016115A2E0802F182340").parse).to eq 23
    expect(vsum PacketParser.new("A0016C880162017C3686B18A3D4780").parse).to eq 31
  end

  it "evaluates packets" do
    expect(evaluate PacketParser.new("C200B40A82").parse).to eq 3
    expect(evaluate PacketParser.new("04005AC33890").parse).to eq 54
    expect(evaluate PacketParser.new("880086C3E88112").parse).to eq 7
    expect(evaluate PacketParser.new("CE00C43D881120").parse).to eq 9
    expect(evaluate PacketParser.new("D8005AC2A8F0").parse).to eq 1
    expect(evaluate PacketParser.new("F600BC2D8F").parse).to eq 0
    expect(evaluate PacketParser.new("9C005AC2F8F0").parse).to eq 0
    expect(evaluate PacketParser.new("9C0141080250320F1802104A08").parse).to eq 1
  end
end
