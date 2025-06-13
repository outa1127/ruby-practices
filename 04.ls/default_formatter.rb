# frozen_string_literal: true

class DefaultFormatter
  COLS = 3

  def initialize(items)
    @items = items
  end

  def format
    items_table = split_items
    width = @items.map { |item| item.name.length }.max
    items_table.map do |row|
      format_row(row, width)
    end
  end

  private

  def split_items
    row_count = @items.size.ceildiv(COLS)
    col_items = @items.each_slice(row_count).to_a

    row_items = Array.new(row_count) do |row|
      Array.new(COLS) do |col|
        col_items[col][row]
      end
    end

    row_items.map(&:compact)
  end

  def format_row(row, width)
    cols = row.map do |item|
      item.name.ljust(width + 2)
    end
    cols.join
  end
end
