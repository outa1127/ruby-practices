#!/usr/bin/env ruby
# frozen_string_literal: true

# score = ARGV[0]
score = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'

# splitメソッドで引数で指定した','ごとに区切った新たな配列を生成する
scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X' # X(ストライク)だったら配列に10と0を追加
    shots << 10
    shots << 0
  else
    shots << s.to_i # それ以外は数値に変換して配列に追加
  end
end

frames = shots.each_slice(2).to_a

if frames.length == 12 # 配列が12だった場合
  frames[-3..-1] = [frames[-3] + frames[-2] + frames[-1]] # 最後の三つの配列を結合
elsif frames.length == 11 # 配列が11だった場合
  frames[-2..-1] = [frames[-2] + frames[-1]] # 最後の二つの配列を結合
end

def strike?(frame)
  frame[0] == 10
end

def not_strike?(frame)
  frame[0] != 10
end

def spare?(frame)
  frame.sum == 10
end

point = 0
# 9フレームだけ他のフレームと挙動が異なる必要がある
frames.each_with_index do |frame, i|
  point +=
    if (i < 8) && strike?(frame) && strike?(frames[i + 1]) # 8フレーム以下かつストライクかつ次もストライク(次もストライクの場合、その次の1投目を足す必要がある)
      frame.sum + frames[i + 1].sum + frames[i + 2][0]
    elsif (i < 8) && strike?(frame) && not_strike?(frames[i + 1]) # 8フレーム以下かつストライクかつ次がストライクでない
      frame.sum + frames[i + 1].sum
    elsif (i < 8) && spare?(frame) # 8フレーム以下かつスペア
      frame.sum + frames[i + 1][0]
    elsif (i == 8) && strike?(frame) && strike?(frames[i + 1]) # 9フレームかつストライクかつ10フレーム目の第1投目がストライク
      frame.sum + frames[9][0] + frames[9][2]
    elsif (i == 8) && strike?(frame) && not_strike?(frames[i + 1]) # 9フレームかつストライクかつ10フレーム目の第1投目がストライクでない
      frame.sum + frames[9][0] + frames[9][1]
    elsif (i == 8) && spare?(frame) # 9フレーム目かつスペア
      frame.sum + frames[9][0]
    else
      frame.sum # それ以外（10フレーム目は最終のため必然的にここに入る）
    end
end

puts point
