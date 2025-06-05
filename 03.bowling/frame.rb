# frozen_string_literal: true

require_relative 'shot'

STRIKE_SCORE = 10

class Frame
  def initialize(first_mark, second_mark = 0, third_mark = 0)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def base_score
    shots.sum
  end

  def strike?
    shots[0] == STRIKE_SCORE
  end

  def spare?
    not_strike? && shots.sum == 10
  end

  def shots
    [@first_shot.score, @second_shot.score, @third_shot.score]
  end
end
