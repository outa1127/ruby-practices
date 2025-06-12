# frozen_string_literal: true

require_relative 'option'
require_relative 'long_formatter'
require_relative 'default_formatter'

class List
  def initialize
    @options = Option.new(ARGV)
  end

  def print_list
    items = fetch_items
    formatter = @options.long ? LongFormatter.new(items) : DefaultFormatter.new(items)
    formatter.format
  end

  private

  def fetch_items
    flags = @options.dotmatch_flags
    files = Dir.glob('*', flags).sort
    @options.reverse ? files.reverse : files
  end
end
