require "pry"

class Frame
  def initialize(frame_number:)
    @frame_number = frame_number
    @rolls = []
  end

  def add(roll)
    @rolls.push(roll)
  end

  def finished?
    if final_frame?
      (score < 10 && @rolls.size == 2) || @rolls.size == 3
    else
      score == 10 || @rolls.size == 2
    end
  end

  def score
    @rolls.inject(0) { |sum, r| sum + r.point }
  end

  def total_score
    score + additional_score
  end

  private

  def final_frame?
    @frame_number == 10
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
    @rolls[0].point == 10
  end

  def additional_score
    return 0 unless spare? || strike?
    return calculate_spare_score if spare?
    return calculate_strike_score if strike?
  end

  def calculate_spare_score
    return 0 unless next_roll
    next_roll.point
  end

  def calculate_strike_score
    return 0 unless next_roll && next_two_roll
    next_roll.point + next_two_roll.point
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
  def initialize(roll_points)
    @frames = []
    frame = nil
    previous_roll = nil
    roll_points.each do |point|
      frame = Frame.new(frame_number: @frames.size + 1) unless frame
      roll = Roll.new(point: point)
      previous_roll.next_roll = roll if previous_roll
      previous_roll = roll
      frame.add roll
      if frame.finished?
        @frames << frame
        frame = nil
      end
    end
    @frames << frame if frame
    if @frames.size > 10
      # use squish on rails
      throw <<-MSG
        Error: found #{@frames.size} frames, a bowling game should only consist of 10 frames.
        Please check your input
      MSG
    end
  end

  def calculate
    @frames.inject(0) { |sum, frame| sum + frame.total_score }
  end
end
