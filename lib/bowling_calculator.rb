require "pry"

class Frame
  def initialize()
    @rolls = []
  end

  def finished?
    score == 10 || @rolls.size >= 2
  end

  def score
    @rolls.inject(0) { |sum, r| sum + r.point }
  end

  def add(roll)
    @rolls.push(roll)
  end

  def spare?
    !strike? && score == 10
  end

  def strike?
    @rolls.first == 10
  end

  def first_roll
    @rolls[0]
  end

  def second_roll
    @rolls[1]
  end
end

class Roll
  attr_accessor :point

  def initialize(point:)
    @point = point
  end
end

class BowlingCalculator
  def initialize(rolls)
    @frames = []
    frame = Frame.new
    rolls.each_with_index do |point|
      roll = Roll.new(point: point)
      frame.add(roll)
      if frame.finished?
        @frames << frame
        frame = Frame.new
      end
    end
  end

  def calculate
    total = 0
    @frames.each_with_index do |frame, index|
      total = total + frame.score
      if frame.spare? && (index + 1 <= @frames.size - 1)
        total = total + @frames[index + 1].first_roll.point
      end
      if frame.strike? && (index + 1 <= @frames.size - 1)
        total = total + @frames[index + 1].first_roll.point + @frames[index + 1].second_roll.point
      end
      p "index #{index} this frame score: #{frame.score}, total #{total}"
    end
    total
  end
end
