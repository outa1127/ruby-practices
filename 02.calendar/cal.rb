#!/usr/bin/env ruby
require "date"
require "optparse"

opt = OptionParser.new

params = {}

opt.on('-y', '--year YEAR', Integer) { |v| params[:year] = v }
opt.on('-m', '--month MONTH', Integer) { |v| params[:month] = v }
opt.parse!(ARGV)

def month_year(month, year)
  year ||= Date.today.year
  month ||= Date.today.month

  # 月と年を表示する箇所
  puts "      #{month}月 #{year}"

  # 曜日を表示する箇所
  puts "Su Mo Tu We Th Fr Sa"

  start_day = Date.new(year, month)
  last_day = Date.new(year, month, -1)
  print '   ' * (start_day.wday)
  (start_day..last_day).each do |date|
    print "#{date.day.to_s.rjust(2)} "
    puts if date.saturday?
  end
  puts
end

month_year(params[:month], params[:year])
