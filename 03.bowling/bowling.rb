#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]

scores = score.split(',')
STRIKE_SCORE = 10

shots = []
scores.each do |s|
  if s == 'X'
    shots << STRIKE_SCORE
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

if frames.length == 12
  frames[-3..] = [frames[-3..].flatten]
elsif frames.length == 11
  frames[-2..] = [frames[-2..].flatten]
end

def strike?(frame)
  frame[0] == STRIKE_SCORE
end

def not_strike?(frame)
  frame[0] != STRIKE_SCORE
end

def spare?(frame)
  frame.sum == STRIKE_SCORE
end

point = 0
frames.each_with_index do |frame, i|
  point +=
    if (i < 8)
      if strike?(frame) && strike?(frames[i + 1])
        frame.sum + frames[i + 1].sum + frames[i + 2][0]
      elsif strike?(frame) && not_strike?(frames[i + 1])
        frame.sum + frames[i + 1].sum
      elsif spare?(frame)
        frame.sum + frames[i + 1][0]
      else
        frame.sum
      end
    elsif (i == 8)
      if strike?(frame) && strike?(frames[i + 1]) 
        frame.sum + frames[i + 1][0] + frames[i + 1][2]
      elsif strike?(frame) && not_strike?(frames[i + 1])
        frame.sum + frames[i + 1][0] + frames[i + 1][1]
      elsif spare?(frame)
        frame.sum + frames[i + 1][0]
      else
        frame.sum
      end
    else
      frame.sum
    end
end

puts point
