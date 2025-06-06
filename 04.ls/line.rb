# frozen_string_literal: true

require_relative 'item'

# Lineクラスでは配列をわたし、整形した状態のデータを返す

class Line
  def initialize(files)
    @files = files

    @items = @files.map do |file|
      Item.new(file)
    end
    # @first_file = Item.new(first_file)
    # @second_file = Item.new(second_file)
    # @third_file = Item.new(third_file)
  end

  # def print_group
  #   [@first_file, @second_file, @third_file]
  # end

  def formatting_row(width)
    @files.map do |file|
      file.ljust(width + 2)
    end
  end
end
