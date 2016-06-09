
require "bowling_calculator"

RSpec.describe BowlingCalculator, "#score" do
  it "sums" do
    frames = []
    12.times { frames.push(10) }
    bowling = BowlingCalculator.new(frames)
    expect(bowling.calculate).to eq 300
  end

  it "sums more" do
    bowling = BowlingCalculator.new(%w(1 2 3 4).map{ |i| i.to_i })
    expect(bowling.calculate).to eq 10
  end

  it "calculates spares correctly", focus: true do
    bowling = BowlingCalculator.new(%w(9 1 9 1).map{ |i| i.to_i })
    expect(bowling.calculate).to eq 29
  end

  it "calculates strike correctly" do
    bowling = BowlingCalculator.new(%w(1 1 1 1 10 1 1).map{ |i| i.to_i })
    expect(bowling.calculate).to eq 18
  end

  it "returns current when the score is still in calculation" do
    bowling = BowlingCalculator.new(%w(10 1).map{ |i| i.to_i })
    expect(bowling.calculate).to eq "current"
  end
end
