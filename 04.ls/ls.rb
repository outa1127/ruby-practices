# frozen_string_literal: true

current_dir_contents = Dir.glob("*", File::FNM_DOTMATCH)
sliced_contents = current_dir_contents.each_slice(3).to_a
rows = sliced_contents.length
cols = sliced_contents.length >= 1 ? sliced_contents.first.length : 0

indexed_contents = Array.new(cols) do |col|
  Array.new(rows) do |row|
    sliced_contents[row][col]
  end
end

formatted_contents = indexed_contents.map do |index_content|
  index_content.compact.map do |element|
    element.ljust(15)
  end.join
end
puts formatted_contents
