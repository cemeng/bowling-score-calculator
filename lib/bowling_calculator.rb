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

  def has_additional_score?
    spare? || strike?
  end

  def first_roll
    @rolls[0]
  end

  def second_roll
    @rolls[1]
  end

  def next_roll
    @rolls.last.next_roll
  end

  def next_two_roll
    @rolls.last.next_roll.next_roll
  end

  def spare?
    !strike? && score == 10
  end

  def strike?
    first_roll.point == 10
  end
end

class Roll
  attr_reader :point
  attr_accessor :next_roll

  def initialize(point:)
    @point = point
  end
end

class BowlingCalculator
  def initialize(rolls)
    @frames = []
    frame = Frame.new
    previous_roll = nil
    rolls.each_with_index do |point|
      roll = Roll.new(point: point)
      previous_roll.next_roll = roll if previous_roll
      previous_roll = roll
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
      if frame.has_additional_score?
        return "current" unless can_calculate_additional_scores_for frame
        total = total + calculate_additional_scores_for(frame)
      end
      p "index #{index} this frame score: #{frame.score}, total #{total}"
    end
    total
  end

  private

  def can_calculate_additional_scores_for(frame)
    (frame.spare? && frame.next_roll) || (frame.strike? && frame.next_roll && frame.next_two_roll)
  end

  def calculate_additional_scores_for(frame)
    frame.next_roll.point if frame.spare?
    frame.next_roll.point + frame.next_two_roll.point if frame.strike?
  end
end
