# frozen_string_literal: true

require_relative 'format'

class List
  def initialize
    @files = formatting_files(Dir.glob('*'))

    @formats = @files.map do |file|
      Format.new(*file)
    end
  end

  def formatting_files(files)
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

  def print_list
    @formats.each(&:formatting)
  end
end
