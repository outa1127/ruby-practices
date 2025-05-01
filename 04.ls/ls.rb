# frozen_string_literal: true

require 'optparse'

option_used = false

def no_option
  current_dir_contents = Dir.glob('*', File::FNM_DOTMATCH)
  delete_secret_file_contents = current_dir_contents.reject { |current_dir_content| current_dir_content.start_with?('.') }
  cols = 3
  rows = delete_secret_file_contents.length >= 1 ? (delete_secret_file_contents.size.to_f / cols).ceil : 0 # 5
  sliced_contents = delete_secret_file_contents.each_slice(rows).to_a

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

def a_option
  current_dir_contents = Dir.glob('*', File::FNM_DOTMATCH)
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
end

OptionParser.new do |opt|
  opt.on('-a') do
    option_used = true
    a_option
  end
  opt.parse!(ARGV)
end

no_option unless option_used
