# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  if !ARGV.empty?
    process_files(options)
  elsif !$stdin.tty?
    print_stats_from_stdin(options)
  else
    exit
  end
end

def parse_options
  opt = OptionParser.new
  params = { l: false, w: false, c: false }
  opt.on('-l') { params[:lines] = true }
  opt.on('-w') { params[:words] = true }
  opt.on('-c') { params[:bytes] = true }

  opt.parse!(ARGV)
  params.values.any? ? params : { lines: true, words: true, bytes: true }
end

def print_stats_from_stdin(options)
  input = $stdin.read

  stats = {
    lines: count_line(input),
    words: count_word(input),
    bytes: count_byte(input)
  }

  formatted_stats = stats.map do |key, value|
    format_stat(value) if options[key]
  end

  puts formatted_stats.join
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

def process_files(options)
  input_files = ARGV

  totals = { lines: 0, words: 0, bytes: 0 }

  input_files.each do |input_file|
    file_content = File.read(input_file)
    stats = collect_stats(file_content, input_file)
    print_stats(stats, options, input_file)
    totals = calculate_stats(totals, stats)
  end

  return unless ARGV.size >= 2

  print_total_stats(totals, options)
end

def collect_stats(file_content, input_file)
  {
    lines: count_line(file_content),
    words: count_word(file_content),
    bytes: File.size(input_file)
  }
end

def print_stats(stats, options, input_file)
  stats_display = []
  stats.each do |key, value|
    stats_display << format_stat(value) if options[key]
  end

  puts "#{stats_display.join} #{input_file}"
end

def calculate_stats(totals, stats)
  totals.merge(stats) { |_key, base_value, add_value| base_value + add_value }
end

def print_total_stats(totals, options)
  total_stats_string_format = totals.map do |key, value|
    format_stat(value) if options[key]
  end

  puts "#{total_stats_string_format.join} total"
end

main
