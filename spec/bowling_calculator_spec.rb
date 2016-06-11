require "bowling_calculator"

RSpec.describe BowlingCalculator, "#calculate" do
  it "calculates the perfect game" do
    frames = []
    12.times { frames.push(10) }
    expect(BowlingCalculator.new(frames).calculate).to eq 300
  end

  it "calculates basic scenario correctly" do
    bowling = BowlingCalculator.new(%w(1 2 3 4).map{ |i| i.to_i })
    expect(bowling.calculate).to eq 10
  end

  it "calculates spares correctly" do
    bowling = BowlingCalculator.new(%w(9 1 9 1).map{ |i| i.to_i })
    expect(bowling.calculate).to eq 29
  end

  it "calculates strike correctly" do
    bowling = BowlingCalculator.new(%w(1 1 1 1 10 1 1).map{ |i| i.to_i })
    expect(bowling.calculate).to eq 18
  end

  it "calculate a complete strike" do
    bowling = BowlingCalculator.new(%w(10 1 1).map{ |i| i.to_i })
    expect(bowling.calculate).to eq 14
  end

  it "returns current score even when a complete score for a strike cannot be calculated" do
    bowling = BowlingCalculator.new(%w(10 1).map{ |i| i.to_i })
    expect(bowling.calculate).to eq 11
  end
end
