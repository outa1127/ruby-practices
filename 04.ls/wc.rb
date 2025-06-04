# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  if !ARGV.empty?
    input_files = ARGV
    process_files(options, input_files)
  elsif from_pipe?
    input_files = [$stdin.read]
    process_files(options, input_files)
  else
    exit
  end
end

def parse_options
  opt = OptionParser.new
  params = { lines: false, words: false, bytes: false }
  opt.on('-l') { params[:lines] = true }
  opt.on('-w') { params[:words] = true }
  opt.on('-c') { params[:bytes] = true }

  opt.parse!(ARGV)
  params.values.any? ? params : { lines: true, words: true, bytes: true }
end

def from_pipe?
  !$stdin.tty?
end

def count_line(input)
  input.count("\n")
end

def count_word(input)
  input.split(/\s+/).size
end

def count_byte(input)
  input.size
end

def format_stat(value)
  value.to_s.rjust(8)
end

def process_files(options, input_files)
  totals = { lines: 0, words: 0, bytes: 0 }

  input_files.each do |input_file|
    file_content = from_pipe? ? input_file : File.read(input_file)
    stats = collect_stats(file_content, input_file)
    print_stats(stats, options, input_file)
    totals = calculate_stats(totals, stats)
  end

  return unless ARGV.size >= 2

  print_stats(totals, options)
end

def collect_stats(file_content, input_file)
  {
    lines: count_line(file_content),
    words: count_word(file_content),
    bytes: from_pipe? ? count_byte(file_content) : File.size(input_file)
  }
end

def print_stats(stats, options, input_file = 'total')
  formatted_stats = stats.map do |key, value|
    format_stat(value) if options[key]
  end

  if from_pipe?
    puts formatted_stats.join
  else
    puts "#{formatted_stats.join} #{input_file}"
  end
end

def calculate_stats(totals, stats)
  totals.merge(stats) { |_key, base_value, add_value| base_value + add_value }
end

main
