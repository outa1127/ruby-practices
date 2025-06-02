#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :results

  def initialize(results)
    @results = results

    new_frames = result_to_frame(formatting_results)

    @frames = new_frames.map do |frame|
      Frame.new(*frame)
    end
  end

  def formatting_results
    shots = []
    results.map do |result|
      if result == 'X'
        shots << STRIKE_SCORE
        shots << :no_score
      else
        shots << result.to_i
      end
    end

    shots
  end

  def result_to_frame(format_result)
    frames = format_result.each_slice(2).to_a
    format_frames = frames.map { |frame| frame.reject { |value| value == :no_score } }
    format_frames[9..] = [format_frames[9..].flatten]
    format_frames
  end

  def total_score
    # total_score = @frames.map(&:score).sum
    total_score = @frames.map.with_index do |frame, index|
      frame.score(@frames, index)
    end
    total_score.sum
  end
end

results = ARGV[0].split(',')
game = Game.new(results)
puts game.total_score
