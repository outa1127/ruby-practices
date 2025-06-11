# frozen_string_literal: true

class DefaultFormatter
  def initialize(files)
    @files = files
  end

  def format_default(max_width)
    formatted_row = @files.map do |file|
      file.ljust(max_width + 2)
    end
    formatted_row.join
  end
end
