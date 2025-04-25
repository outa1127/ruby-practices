#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]

scores = score.split(',')
STRIKE_SCORE = 10
STRIKE_SECOND_THROW_SCORE = 0

shots = []
scores.each do |s|
  if s == 'X'
    shots << STRIKE_SCORE
    shots << STRIKE_SECOND_THROW_SCORE
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

frames[9..] = [frames[9..].flatten]

def strike?(frame)
  frame[0] == STRIKE_SCORE
end

def not_strike?(frame)
  frame[0] != STRIKE_SCORE
end

def spare?(frame)
  frame[0] != 10 && frame.sum == STRIKE_SCORE
end

point = 0

# frames.sum { |frame| frame.sum}と同じ意味
point += frames.sum(&:sum)

NO_BONUS_SCORE = 0

frames.each_with_index do |frame, i|
  next if i >= 9

  point +=
    if strike?(frame) && strike?(frames[i + 1])
      if i == 8
        frames[i + 1][0] + frames[i + 1][2]
      else
        frames[i + 1][0] + frames[i + 2][0]
      end
    elsif strike?(frame) && not_strike?(frames[i + 1])
      frames[i + 1][0] + frames[i + 1][1]
    elsif spare?(frame)
      frames[i + 1][0]
    else
      NO_BONUS_SCORE
    end
end

puts point
