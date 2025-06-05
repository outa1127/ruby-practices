# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  input_files =
    if ARGV.any?
      ARGV.map do |file|
        { name: file, text: File.read(file) }
      end
    else
      [{ name: '', text: $stdin.read }]
    end
  process_files(options, input_files)
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

def process_files(options, input_files)
  totals = { lines: 0, words: 0, bytes: 0, name: 'total' }

  input_files.each do |input_file|
    stats = collect_stats(input_file)
    print_stats(stats, options)
    totals[:lines] += stats[:lines]
    totals[:words] += stats[:words]
    totals[:bytes] += stats[:bytes]
  end

  return unless ARGV.size >= 2

  print_stats(totals, options)
end

def collect_stats(input_file)
  {
    lines: count_line(input_file[:text]),
    words: count_word(input_file[:text]),
    bytes: count_byte(input_file[:text]),
    name: input_file[:name]
  }
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

def print_stats(stats, options)
  formatted_stats = %i[lines words bytes].map do |key|
    format_stat(stats[key]) if options[key]
  end
  puts "#{formatted_stats.join} #{stats[:name]}"
end

def format_stat(value)
  value.to_s.rjust(8)
end

main
