# frozen_string_literal: true

require 'optparse'

class Option
  attr_reader :reverse

  def initialize(argv)
    @all = false
    @reverse = false
    @long = false

    OptionParser.new do |opt|
      opt.on('-a') { @all = true }
      opt.on('-r') { @reverse = true }
      opt.on('-l') { @long = true }
    end.parse!(argv)
  end

  def dotmatch_flags
    @all ? File::FNM_DOTMATCH : 0
  end
end
