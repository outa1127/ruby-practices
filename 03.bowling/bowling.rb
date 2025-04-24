#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]

# splitメソッドで引数で指定した','ごとに区切った新たな配列を生成する
scores = score.split(',')
STRIKE_SCORE = 10

shots = []
scores.each do |s|
  if s == 'X' # X(ストライク)だったら配列に10と0を追加
    shots << STRIKE_SCORE
    shots << 0
  else
    shots << s.to_i # それ以外は数値に変換して配列に追加
  end
end

frames = shots.each_slice(2).to_a

if frames.length == 12 # 配列が12だった場合
  frames[-3..] = [frames[-3..].flatten] # 最後の三つの配列を結合
elsif frames.length == 11 # 配列が11だった場合
  frames[-2..] = [frames[-2..].flatten] # 最後の二つの配列を結合
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
# # 9フレームだけ他のフレームと挙動が異なる必要がある
frames.each_with_index do |frame, i|
  point +=
    if (i < 8)
      if strike?(frame) && strike?(frames[i + 1])
        frame.sum + frames[i + 1].sum + frames[i + 2][0]
      elsif strike?(frame) && not_strike?(frames[i + 1])
        frame.sum + frames[i + 1].sum
      elsif spare?(frame) # 8フレーム以下かつスペア
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
