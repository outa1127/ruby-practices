# frozen_string_literal: true

require 'optparse'

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

def print_stats_from_stdin
  input = $stdin.read

  print_stats_pipe = []
  print_stats_pipe << print_line(input)
  print_stats_pipe << print_word(input)
  print_stats_pipe << print_byte(input)

  print_stats_pipe_formatted = print_stats_pipe.map { |stat| format_stat(stat) }.join
  puts print_stats_pipe_formatted
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

def parse_options
  opt = OptionParser.new
  params = { l: false, w: false, c: false }
  opt.on('-l') { params[:l] = true }
  opt.on('-w') { params[:w] = true }
  opt.on('-c') { params[:c] = true }

  opt.parse!(ARGV)
  params.values.any? ? params : { l: true, w: true, c: true }
end

def format_stat(value)
  value.to_s.rjust(8)
end

def process_files(option_flag)
  input_files = ARGV

  totals = { lines: 0, words: 0, bytes: 0 }

  input_files.each do |input_file|
    file_content = File.read(input_file)
    stats = print_stats(file_content, input_file, option_flag)
    calculate_stats(totals, stats)
  end

  return unless ARGV.size >= 2

  flag_to_key = { l: :lines, w: :words, c: :bytes }
  total_stats_string_format = flag_to_key.map do |flag_key, total_key|
    format_stat(totals[total_key]) if option_flag[flag_key]
  end

  puts "#{total_stats_string_format.join} total"
end

def print_stats(file_content, input_file, option_flag)
  lines = print_line(file_content)
  words = print_word(file_content)
  bytes = File.size(input_file)

  stats_values = {}
  stats_display = []

  value_refalence = [
    [:l, lines, :lines],
    [:w, words, :words],
    [:c, bytes, :bytes]
  ]

  value_refalence.each do |flag_key, stats_value, stats_key|
    if option_flag[flag_key]
      stats_values[stats_key] = stats_value
      stats_display << format_stat(stats_value)
    end
  end

  puts "#{stats_display.join} #{input_file}"
  stats_values
end

def calculate_stats(totals, stats)
  totals.each_key do |key|
    totals[key] += stats[key] if stats[key]
  end
end

main
