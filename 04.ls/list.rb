# frozen_string_literal: true

require_relative 'option'
require_relative 'line'

class List
  def initialize
    @options = Option.new(ARGV)

    files = fetch_files

    if @options.long
      rows = [files]
    else
      rows = formatting_rows(files)
      @column_width = files.max_by(&:length).length
    end

    @lines = collect_lines(rows)
  end

  def print_list
    @lines.each do |line|
      if @options.long
        puts line.formatting_long
      else
        puts line.formatting_default(@column_width)
      end
    end
  end

  private

  def fetch_files
    flags = @options.dotmatch_flags
    files = Dir.glob('*', flags).sort
    @options.reverse ? files.reverse : files
  end

  def collect_lines(files)
    files.map do |file|
      Line.new(file)
    end
  end

  def formatting_rows(files)
    cols = 3
    rows = files.length >= 1 ? (files.size.to_f / cols).ceil : 0
    sliced_contents = files.each_slice(rows).to_a

    indexed_contents = Array.new(rows) do |row|
      Array.new(cols) do |col|
        sliced_contents[col][row]
      end
    end

    indexed_contents.map(&:compact)
  end
end
