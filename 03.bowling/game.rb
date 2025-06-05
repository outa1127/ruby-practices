#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(results)
    @results = results

    formatted_frames = separate_results_per_frame

    @frames = formatted_frames.map do |frame|
      Frame.new(*frame)
    end
  end

  def total_score
    total_score = 0
    @frames.each_with_index do |frame, index|
      total_score += frame.base_score

      next if index >= 9

      total_score +=
        if frame.strike?
          calculate_strike_bonus(index)
        elsif frame.spare?
          calculate_spare_bonus(index)
        else
          0
        end
    end

    total_score
  end

  private

  def separate_results_per_frame
    shots = []
    shot_index = 0

    while shot_index < @results.size
      if @results[shot_index] == 'X'
        shots << [STRIKE_SCORE]
        shot_index += 1
      else
        shots << [@results[shot_index], @results[shot_index + 1]]
        shot_index += 2
      end
    end

    shots[9..] = [shots[9..].flatten[0..2]]
    shots
  end

  def calculate_strike_bonus(frame_index)
    next_frame = @frames[frame_index + 1]
    after_next_frame = @frames[frame_index + 2]

    if next_frame.strike? && frame_index != 8
      next_frame.shots[0] + after_next_frame.shots[0]
    else
      next_frame.shots[0..1].sum
    end
  end

  def calculate_spare_bonus(frame_index)
    @frames[frame_index + 1].shots[0]
  end
end
