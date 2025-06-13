# frozen_string_literal: true

require_relative 'options'
require_relative 'long_formatter'
require_relative 'default_formatter'

class List
  def initialize
    @options = Options.new(ARGV)
  end

  def print_list
    items = fetch_items

    return if items.empty?

    formatter = @options.long? ? LongFormatter.new(items) : DefaultFormatter.new(items)
    puts formatter.format
  end

  private

  def fetch_items
    flags = @options.dotmatch_flag
    file_names = Dir.glob('*', flags)
    sorted_file_names = @options.reverse? ? file_names.sort.reverse : file_names.sort

    sorted_file_names.map do |file_name|
      Item.new(file_name)
    end
  end
end
