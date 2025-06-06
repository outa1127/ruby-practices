# frozen_string_literal: true

require_relative 'line'

class List
  def initialize
    files = Dir.glob('*')
    @rows = formatting_rows(files)
    @column_width = files.max_by(&:length).length

    @lines = @rows.map do |row|
      Line.new(row)
    end
  end

  def print_list
    @lines.each do |line|
      puts line.formatting_row(@column_width).join
    end
  end

  private

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
