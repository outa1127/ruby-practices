# frozen_string_literal: true

require_relative 'item'

class Line
  def initialize(files)
    @files = files

    @items = @files.each do |file|
      Item.new(file)
    end
    # @first_file = Item.new(first_file)
    # @second_file = Item.new(second_file)
    # @third_file = Item.new(third_file)
  end

  def print_group
    [@first_file, @second_file, @third_file]
  end

  def formatting
    @files.map do |file|
      file.ljust(15)
    end
  end
end
