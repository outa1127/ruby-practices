# frozen_string_literal: true

require_relative 'option'
require_relative 'long_formatter'
require_relative 'default_formatter'

class List
  def print_list
    @options = Option.new(ARGV)

    items = fetch_items

    if @options.long
      long_formatters = build_long_formatters(items)
      puts "total #{get_total_block_size(long_lines)}"

      long_formatters.each do |long_formatter|
        puts long_formatter.to_long_format
      end
    else
      formatted_rows = format_rows(items)
      item_max_width = items.max_by(&:length).length
      default_fomatters = build_default_formatters(formatted_rows)

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

  def build_long_formatters(items)
    items.map do |item|
      LongFormatter.new(item)
    end
  end

  def get_total_block_size(long_lines)
    long_lines.sum(&:calculate_total_block_size)
  end

  def build_default_formatters(rows)
    rows.map do |row|
      DefaultFormatter.new(row)
    end
  end

  def format_rows(files)
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
