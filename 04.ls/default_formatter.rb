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
    rows_number = @items.size.ceildiv(COLS)
    cols_item = @items.each_slice(rows_number).to_a

    rows_item = Array.new(rows_number) do |row|
      Array.new(COLS) do |col|
        cols_item[col][row]
      end
    end

    rows_item.map(&:compact)
  end

  def format_row(row, width)
    cols = row.map do |item|
      item.name.ljust(width + 2)
    end
    cols.join
  end
end
