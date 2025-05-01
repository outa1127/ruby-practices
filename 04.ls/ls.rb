# frozen_string_literal: true

opt = OptionParser.new
opt.on('-a') { puts '-a option' }
opt.parse(ARGV)

current_dir_contents = Dir.glob("*", File::FNM_DOTMATCH)
cols = 3
rows = current_dir_contents.length >= 1 ? (current_dir_contents.size.to_f / cols).ceil : 0 # 5
sliced_contents = current_dir_contents.each_slice(rows).to_a

indexed_contents = Array.new(rows) do |row|
  Array.new(cols) do |col|
    sliced_contents[col][row]
  end
end

formatted_contents = indexed_contents.map do |index_content|
  index_content.compact.map do |element|
    element.ljust(15)
  end.join
end
puts formatted_contents
