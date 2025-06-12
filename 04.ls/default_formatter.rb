# frozen_string_literal: true

class DefaultFormatter
  def initialize(items)
    @items = items
  end

  def format
    all_items_per_row = split_items
    width = calculate_max_width
    all_items_per_row.map do |items_row|
      format_items(items_row, width)
    end
  end

  private

  def split_items
    cols = 3
    rows = @items.length >= 1 ? (@items.size.to_f / cols).ceil : 0
    items_per_colmun = @items.each_slice(rows).to_a

    items_per_row = Array.new(rows) do |row|
      Array.new(cols) do |col|
        items_per_colmun[col][row]
      end
    end

    items_per_row.map(&:compact)
  end

  def calculate_max_width
    @items.max_by(&:length).length
  end

  def format_items(items_row, width)
    formatted_row = items_row.map do |item|
      item.ljust(width + 2)
    end
    formatted_row.join
  end
end
