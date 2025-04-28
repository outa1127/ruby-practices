# frozen_string_literal: true

current_dir_contents = Dir.glob("*", File::FNM_DOTMATCH)
sliced_contents = current_dir_contents.each_slice(3).to_a # 表示する列数を修正するときはここの数字を変更

rows = sliced_contents.length # 配列の数。[[1,2],[3,4],[5,6]]だったら3
cols = sliced_contents.length >= 1 ? sliced_contents.first.length : 0 # 配列の中の要素の数。上の例で言うと2
new_array = [] # 修正後の配列を格納する新たな配列

# 以下の繰り返し処理を実行することで、sliced_contents[0~3][0]の要素、sliced_contents[0~3][１]みたいな感じで配列を再生成できる。
cols.times do |col|
  new_row = []
  rows.times do |row|
    new_row << sliced_contents[row][col]
  end
  new_array << new_row
end

new_array.each do |inner_array|
  formatted_line = inner_array.compact.map do |element| # compactメソッドを使用することでnilの配列を排除してmap関数を実行することができる
    element.ljust(15) # 左よせ15文字文のスペースでファイルを表示するようにする
  end
  puts formatted_line.join
end
