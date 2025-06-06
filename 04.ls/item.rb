# frozen_string_literal: true

class Item
  def initialize(name)
    @name = name
  end

  def format_ljust
    @name.ljust(15)
  end
end
