# frozen_string_literal: true

class DefaultFormatter
  def initialize(row)
    @row = row
  end

  def to_default_format(max_width)
    formatted_row = @row.map do |item|
      item.ljust(max_width + 2)
    end
    formatted_row.join
  end
end
