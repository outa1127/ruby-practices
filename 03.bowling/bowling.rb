#!/usr/bin/env ruby
require 'debug'

score = ARGV[0]

# splitメソッドで引数で指定した','ごとに区切った新たな配列を生成する
scores = score.split(',')

shots = []
scores.each do |s|
  # binding.break
  if s == 'X' # X(ストライク)だったら配列に10と0を追加
    shots << 10
    shots << 0
  else
    shots << s.to_i # それ以外は数値に変換して配列に追加
  end
end

frames = []
shots.each_slice(2) do |s| # 配列をフレームごと（2つの数字）わけ、繰り返し処理を実施
  frames << s # 配列の中に配列を代入していく
end

if frames.length == 12 # 配列が12だった場合
  frames[-3..-1] = [frames[-3] + frames[-2] + frames[-1]] # 最後の三つの配列を結合
elsif frames.length == 11 # 配列が11だった場合
  frames[-2..-1] = [frames[-2] + frames[-1]] # 最後の二つの配列を結合
end

point = 0
# 9フレームだけ他のフレームと挙動が異なる必要がある
frames.each_with_index do |frame, i|
  if (i < 8) && (frame[0] == 10) && (frames[i + 1][0] == 10) # 8フレーム以下かつストライクかつ次もストライク(次もストライクの場合、その次の1投目を足す必要がある)
    point += frame.sum + frames[i + 1].sum + frames[i + 2][0]
  elsif (i < 8) && (frame[0] == 10) && (frames[i + 1][0] != 10)# 8フレーム以下かつストライクかつ次がストライクでない
    point += frame.sum + frames[i + 1].sum
  elsif (i < 8) && (frame.sum == 10) # 8フレーム以下かつスペア
    point += frame.sum + frames[i + 1][0]
  elsif (i == 8) && (frame[0] == 10) && (frames[9][0] == 10) # 9フレームかつストライクかつ10フレーム目の第1投目がストライク
    point += frame.sum + frames[9][0] + frames[9][2]
  elsif (i == 8) && (frame[0] == 10) && (frames[9][0] != 10) # 9フレームかつストライクかつ10フレーム目の第1投目がストライクでない
    point += frame.sum + frames[9][0] + frames[9][1]
  elsif (i == 8) && (frame.sum == 10) # 9フレーム目かつスペア
    point += frame.sum + frames[9][0]
  else
    point += frame.sum # それ以外（10フレーム目は最終のため必然的にここに入る）
  end
end

puts point
