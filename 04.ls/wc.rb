# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  input_files = if !ARGV.empty?
                  ARGV.map do |file|
                    {
                      name: file,
                      text: File.read(file)
                    }
                  end
                else
                  [
                    {
                      name: '',
                      text: $stdin.read
                    }
                  ]
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
  totals = { lines: 0, words: 0, bytes: 0 }

  input_files.each do |input_file|
    stats = collect_stats(input_file)
    print_stats(stats, options, input_file[:name])
    totals[:lines] += stats[:lines]
    totals[:words] += stats[:words]
    totals[:bytes] += stats[:bytes]
  end

  return unless ARGV.size >= 2

  print_stats(totals, options, 'total')
end

def collect_stats(input_file)
  {
    lines: count_line(input_file[:text]),
    words: count_word(input_file[:text]),
    bytes: count_byte(input_file[:text])
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

def format_stat(value)
  value.to_s.rjust(8)
end

def print_stats(stats, options, input_file)
  formatted_stats = stats.map do |key, value|
    format_stat(value) if options[key]
  end
  puts "#{formatted_stats.join} #{input_file}"
end

main
