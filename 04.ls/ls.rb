# frozen_string_literal: true

require 'optparse'

option_used = false

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

OptionParser.new do |opt|
  opt.on('-a') do
    option_used = true
    formatting_contents(Dir.glob('*', File::FNM_DOTMATCH))
  end
  opt.parse!(ARGV)
end

formatting_contents(Dir.glob('*')) unless option_used
