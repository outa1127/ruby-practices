# frozen_string_literal: true

require 'optparse'

def main
  option_flag = parse_args
  word_count_total(option_flag)
end

def format_stat(value)
  value.to_s.rjust(8)
end

def word_count(content, input_file, option_flag)
  lines = content.count("\n")
  words = content.split(/\s+/).size
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
      stats_display << lines
    end
  end

  stats_display_format = stats_display.map { |stat| format_stat(stat) }.join
  puts "#{stats_display_format} #{input_file}"
  stats_values
end

def word_count_total(option_flag)
  return if ARGV.empty?

  input_files = ARGV

  total_lines = 0
  total_words = 0
  total_bytes = 0

  input_files.each do |input_file|
    content = File.read(input_file)
    stats = word_count(content, input_file, option_flag)

    total_lines += stats[:lines] if stats[:lines]
    total_words += stats[:words] if stats[:words]
    total_bytes += stats[:bytes] if stats[:bytes]
  end

  return unless ARGV.size >= 2

  total_stats_string = []
  stats_refalence = [
    [:l, total_lines],
    [:w, total_words],
    [:c, total_bytes]
  ]
  stats_refalence.each do |flag_key, stat_value|
    total_stats_string << stat_value if option_flag[flag_key]
  end

  total_stats_string_format = total_stats_string.map { |stat| format_stat(stat) }.join
  puts "#{total_stats_string_format} total"
end

def parse_args
  opt = OptionParser.new
  params = {}
  opt.on('-l') { params[:l] = true }
  opt.on('-w') { params[:w] = true }
  opt.on('-c') { params[:c] = true }

  opt.parse!(ARGV)
  params.values.any? ? params : { l: true, w: true, c: true }
end

main
