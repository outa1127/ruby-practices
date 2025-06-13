# frozen_string_literal: true

require_relative 'option'
require_relative 'long_formatter'
require_relative 'default_formatter'

class List
  def initialize
    @options = Options.new(ARGV)
  end

  def print_list
    items = fetch_items

    return unless items

    formatter = @options.long? ? LongFormatter.new(items) : DefaultFormatter.new(items)
    puts formatter.format
  end

  private

  def fetch_items
    flags = @options.all?
    items = Dir.glob('*', flags).sort
    items = @options.reverse? ? items.reverse : items

    items.map do |item|
      Item.new(item)
    end
  end
end
