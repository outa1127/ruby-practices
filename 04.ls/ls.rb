current_dir_content = Dir.children('.').sort
 three_children_array = current_dir_content.each_slice(3).to_a # 表示する列数を修正するときはここの数字を変更
 
 rows = three_children_array.length # 配列の数。[[1,2],[3,4],[5,6]]だったら3
 cols = three_children_array.first.length # 配列の中の要素の数。上の例で言うと2
 new_array = [] # 修正後の配列を格納する新たな配列
 
 # 以下の繰り返し処理を実行することで、three_children_array[0~3][0]の要素、three_children_array[0~3][１]みたいな感じで配列を再生成できる。
 (0...cols).each do |j|
   new_row = []
   (0...rows).each do |i|
     new_row << three_children_array[i][j]
   end
   new_array << new_row
 end
 
 new_array.each do |inner_array|
   formatted_line = inner_array.compact.map do |element| # compactメソッドを使用することでnilの配列を排除してmap関数を実行することができる
     element.ljust(10)
   end
   puts formatted_line.join
 end
