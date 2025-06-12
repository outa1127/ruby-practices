# frozen_string_literal: true

require_relative 'option'
require_relative 'long_formatter'
require_relative 'default_formatter'

class List
  def initialize
    @options = Option.new(ARGV)
  end

  def print_list
    @items = fetch_items

    if @options.long
      long_formatters = build_long_formatters

      total_block_size = long_formatters.sum(&:calculate_total_block_size)
      puts "total #{total_block_size}"

      long_formatters.each do |long_formatter|
        puts long_formatter.to_long_format
      end
    else
      items_per_row = split_items_per_row
      item_max_width = @items.max_by(&:length).length
      default_fomatters = build_default_formatters(items_per_row)

      default_fomatters.each do |default_fomatter|
        puts default_fomatter.to_default_format(item_max_width)
      end
    end
  end

  private

  def fetch_items
    flags = @options.dotmatch_flags
    files = Dir.glob('*', flags).sort
    @options.reverse ? files.reverse : files
  end

  def build_long_formatters
    @items.map do |item|
      LongFormatter.new(item)
    end
  end

  def build_default_formatters(rows)
    rows.map do |row|
      DefaultFormatter.new(row)
    end
  end

  def split_items_per_row
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
end
