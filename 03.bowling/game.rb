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

    shots[9..] = [shots[9..].flatten]
    shots
  end

  def total_score
    score_per_frame = @frames.map.with_index do |frame, index|
      frame.score(@frames, index)
    end
    score_per_frame.sum
  end
end

results = ARGV[0].split(',')
game = Game.new(results)
puts game.total_score
