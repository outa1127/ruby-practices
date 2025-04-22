#!/usr/bin/env ruby
require 'debug'
require "date"
require "optparse"

opt = OptionParser.new

params = {}

# onメソッドを使用してオプションの登録
opt.on('-y', '--year YEAR', Integer) {|v| params[:year] = v }
opt.on('-m', '--month MONTH', Integer) {|v| params[:month] = v }
opt.parse!(ARGV)

# paramsでコマンドラインが入力されているか判定、入力されていない場合today_date.yearで今年の値を代入
def month_year(month, year)
  year_to_num = year.to_i
  month_to_num = month.to_i

  # 月と年を表示する箇所
  puts "      #{month}月 #{year}"

  # 曜日を表示する箇所
  puts "Su Mo Tu We Th Fr Sa"

  # 日付を表示する箇所
  start_day= Date.new(year_to_num, month_to_num)
  last_day = Date.new(year_to_num, month_to_num, -1)
  print '   ' * (start_day.wday)
  (start_day..last_day).each do |date|

    # 表示する日付を右詰めで２文字幅で表示する
    print "#{date.day.to_s.rjust(2)} "
    # 土曜日を表示した後に土曜日だったら改行を行うようにする
    puts if date.saturday?
  end
  puts
end

year_to_pass = params[:year].nil? ? Date.today.year : params[:year] 
month_year(params[:month], year_to_pass)
