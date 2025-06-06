#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

results = ARGV[0].split(',')
game = Game.new(results)
puts game.total_score
