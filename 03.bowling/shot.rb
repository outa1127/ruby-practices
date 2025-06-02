#!/usr/bin/env ruby
# frozen_string_literal: true

class Shot
  attr_reader :mark # @markに`mark`でアクセスするためのメソッドを作成

  # 上記で行っていることは以下のようなイメージ
  # def mark
  #   @mark
  # end

  def initialize(mark)
    @mark = mark # 今回でいう'X'をインスタンス変数に保存
  end

  def score
    mark.to_i
  end
end

# shot = Shot.new('X')
# puts shot.mark
# puts shot.score
