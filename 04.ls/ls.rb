# frozen_string_literal: true

require 'optparse'

def formatting_contents(dir_contents)
  cols = 3
  rows = dir_contents.length >= 1 ? (dir_contents.size.to_f / cols).ceil : 0 # 5
  sliced_contents = dir_contents.each_slice(rows).to_a

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
end

flags = 0
reverse_sort = false

OptionParser.new do |opt|
  opt.on('-a') { flags |= File::FNM_DOTMATCH }
  opt.on('-r') { reverse_sort = true }
  opt.parse!(ARGV)
end

sorted_contents = Dir.glob('*', flags).sort
sorted_contents.reverse! if reverse_sort

formatting_contents(sorted_contents)
