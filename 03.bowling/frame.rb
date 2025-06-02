#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'

STRIKE_SCORE = 10

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = 0, third_mark = 0)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def shots
    [first_shot.score, second_shot.score, third_shot.score]
  end

  def strike?
    shots[0] == STRIKE_SCORE
  end

  def not_strike?
    shots[0] != STRIKE_SCORE
  end

  def spare?
    not_strike? && shots.sum == 10
  end

  def strike_bonus(frames, index)
    next_frame = frames[index + 1]
    after_next_frame = frames[index + 2]

    if next_frame.strike?
      if index == 8
        next_frame.first_shot.score + next_frame.second_shot.score
      else
        next_frame.first_shot.score + after_next_frame.first_shot.score
      end
    elsif next_frame.not_strike?
      next_frame.first_shot.score + next_frame.second_shot.score
    end
  end

  def spare_bonus(frames, index)
    frames[index + 1].first_shot.score
  end

  def score(frames, index)
    base_score = shots.sum
    return base_score if index >= 9

    bonus_score = if strike?
                    strike_bonus(frames, index)
                  elsif spare?
                    spare_bonus(frames, index)
                  else
                    0
                  end

    base_score + bonus_score
  end
end
