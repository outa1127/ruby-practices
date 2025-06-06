# frozen_string_literal: true

class Shot
  def initialize(mark)
    @mark = mark
  end

  def score
    @mark.to_i
  end
end
