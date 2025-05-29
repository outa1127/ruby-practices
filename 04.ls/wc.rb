# frozen_string_literal: true

require 'optparse'

OPTION_FLAG_TO_STAT_KEY = {
  l: :lines,
  w: :words,
  c: :bytes
}.freeze

def main
  if !ARGV.empty?
    option_flag = parse_options
    process_files(option_flag)
  elsif !$stdin.tty?
    print_stats_from_stdin
  else
    exit
  end
end

def parse_options
  opt = OptionParser.new
  params = { l: false, w: false, c: false }
  opt.on('-l') { params[:l] = true }
  opt.on('-w') { params[:w] = true }
  opt.on('-c') { params[:c] = true }

  opt.parse!(ARGV)
  params.values.any? ? params : { l: true, w: true, c: true }
end

def print_stats_from_stdin
  input = $stdin.read

  stats = [
    print_line(input),
    print_word(input),
    print_byte(input)
  ]

  puts stats.map { |stat| format_stat(stat) }.join
end

def print_line(input)
  input.count("\n")
end

def print_word(input)
  input.split(/\s+/).size
end

def print_byte(input)
  input.size
end

def format_stat(value)
  value.to_s.rjust(8)
end

def process_files(option_flag)
  input_files = ARGV

  totals = { lines: 0, words: 0, bytes: 0 }

  input_files.each do |input_file|
    file_content = File.read(input_file)
    stats = collect_stats(file_content, input_file)
    print_stats(stats, option_flag, input_file)
    calculate_stats(totals, stats)
  end

  return unless ARGV.size >= 2

  print_total_stats(totals, option_flag)
end

def collect_stats(file_content, input_file)
  {
    lines: print_line(file_content),
    words: print_word(file_content),
    bytes: File.size(input_file)
  }
end

def print_stats(stats, option_flag, input_file)
  stats_display = []

  OPTION_FLAG_TO_STAT_KEY.each do |flag_key, stat_key|
    stats_display << format_stat(stats[stat_key]) if option_flag[flag_key]
  end

  puts "#{stats_display.join} #{input_file}"
end

def calculate_stats(totals, stats)
  totals.each_key do |key|
    totals[key] += stats[key]
  end
end

def print_total_stats(totals, option_flag)
  total_stats_string_format = OPTION_FLAG_TO_STAT_KEY.map do |flag_key, stat_key|
    format_stat(totals[stat_key]) if option_flag[flag_key]
  end

  puts "#{total_stats_string_format.join} total"
end

main
