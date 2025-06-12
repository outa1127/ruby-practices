# frozen_string_literal: true

class DefaultFormatter
  COLS = 3
  def initialize(items)
    @items = items
  end

  def format
    items_table = split_items
    width = @items.map { |item| item.name.length }.max.to_i
    items_table.map do |row|
      format_row(row, width)
    end
  end

  private

  def split_items
    rows = @items.size.ceildiv(COLS)
    items_per_colmun = @items.each_slice(rows).to_a

    items_per_row = Array.new(rows) do |row|
      Array.new(COLS) do |col|
        items_per_colmun[col][row]
      end
    end

    items_per_row.map(&:compact)
  end

  def format_row(row, width)
    cols = row.map do |item|
      item.name.ljust(width + 2)
    end
    cols.join
  end
end
