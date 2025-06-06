# frozen_string_literal: true

require_relative 'item'

class Format
  def initialize(first_file, second_file, third_file = '')
    @first_file = Item.new(first_file)
    @second_file = Item.new(second_file)
    @third_file = Item.new(third_file)
  end

  def print_group
    [@first_file, @second_file, @third_file]
  end

  def formatting
    formatted_file = print_group.map(&:format_ljust)
    puts formatted_file.join
  end
end
